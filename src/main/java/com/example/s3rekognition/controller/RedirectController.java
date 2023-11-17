package com.example.s3rekognition.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.view.RedirectView;

@Controller
public class RedirectController {

    @GetMapping("/")
    public RedirectView redirectToScanPpe() {
        return new RedirectView("/scan-ppe?bucketName=kjellsimagebucket");
    }
}