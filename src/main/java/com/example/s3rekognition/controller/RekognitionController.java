package com.example.s3rekognition.controller;

import com.amazonaws.services.rekognition.AmazonRekognition;
import com.amazonaws.services.rekognition.AmazonRekognitionClientBuilder;
import com.amazonaws.services.rekognition.model.*;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ListObjectsV2Result;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.example.s3rekognition.PPEClassificationResponse;
import com.example.s3rekognition.PPEResponse;
import io.micrometer.core.instrument.*;
import io.micrometer.cloudwatch.CloudWatchConfig;
import io.micrometer.cloudwatch.CloudWatchMeterRegistry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.Duration;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@RestController
public class RekognitionController implements ApplicationListener<ApplicationReadyEvent> {

    private final AmazonS3 s3Client;
    private final AmazonRekognition rekognitionClient;

    @Autowired
    private MeterRegistry meterRegistry;

    private static final Logger logger = Logger.getLogger(RekognitionController.class.getName());

    public RekognitionController() {
        CloudWatchConfig cloudWatchConfig = setupCloudWatchConfig();
        CloudWatchMeterRegistry cloudWatchRegistry = new CloudWatchMeterRegistry(cloudWatchConfig, Clock.SYSTEM);
        meterRegistry.config().meterFilter(MeterFilter.acceptNameStartsWith("candidate2029_"));
        this.s3Client = AmazonS3ClientBuilder.standard().build();
        this.rekognitionClient = AmazonRekognitionClientBuilder.standard().build();
    }
    
    private CloudWatchConfig setupCloudWatchConfig() {
        return new CloudWatchConfig() {
            private final Map<String, String> configuration = Map.of(
                "cloudwatch.namespace", "candidate2029",
                "cloudwatch.step", Duration.ofSeconds(5).toString()
            );

            @Override
            public String get(String key) {
                return configuration.getOrDefault(key, null);
            }
        };
    }

    @Override
    public void onApplicationEvent(ApplicationReadyEvent applicationReadyEvent) {
        logger.info("The application has started and is ready to accept requests.");
    }

    @GetMapping(value = "/scan-ppe", consumes = "*/*", produces = "application/json")
    @ResponseBody
    public ResponseEntity<PPEResponse> scanForPPE(@RequestParam String bucketName) {
        LongTaskTimer scanningTimer = LongTaskTimer.builder("s3.scanning.duration")
                .description("Time taken to scan S3 bucket")
                .register(meterRegistry);

        LongTaskTimer.Sample sample = scanningTimer.start();
        ListObjectsV2Result imageList = s3Client.listObjectsV2(bucketName);
        List<PPEClassificationResponse> classificationResponses = new ArrayList<>();
        List<S3ObjectSummary> images = imageList.getObjectSummaries();
        for (S3ObjectSummary image : images) {
            logger.info("scanning " + image.getKey());
            DetectProtectiveEquipmentRequest request = new DetectProtectiveEquipmentRequest()
                    .withImage(new Image()
                            .withS3Object(new S3Object()
                                    .withBucket(bucketName)
                                    .withName(image.getKey())))
                    .withSummarizationAttributes(new ProtectiveEquipmentSummarizationAttributes()
                            .withMinConfidence(80f)
                            .withRequiredEquipmentTypes("FACE_COVER"));
            DetectProtectiveEquipmentResult result = rekognitionClient.detectProtectiveEquipment(request);
            boolean violation = isViolation(result);
            logger.info("scanning " + image.getKey() + ", violation result " + violation);
            int personCount = result.getPersons().size();
            DistributionSummary personCountSummary = DistributionSummary.builder("s3.person.count")
                    .description("Distribution of persons detected in images")
                    .register(meterRegistry);
            personCountSummary.record(personCount);
            PPEClassificationResponse classification = new PPEClassificationResponse(image.getKey(), personCount, violation);
            classificationResponses.add(classification);
        }
        Gauge.builder("s3.images.processed", classificationResponses, List::size)
                .description("Number of images processed")
                .register(meterRegistry);
        PPEResponse ppeResponse = new PPEResponse(bucketName, classificationResponses);
        sample.stop();
        return ResponseEntity.ok(ppeResponse);
    }

    private static boolean isViolation(DetectProtectiveEquipmentResult result) {
        return result.getPersons().stream()
                .flatMap(p -> p.getBodyParts().stream())
                .anyMatch(bodyPart -> bodyPart.getName().equals("FACE")
                        && bodyPart.getEquipmentDetections().isEmpty());
    }
}
