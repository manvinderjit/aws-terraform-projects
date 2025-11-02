package com.example.frontend.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.ui.Model;
import org.springframework.web.client.RestTemplate;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;

import java.util.Map;
import java.util.Arrays;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;

import com.example.frontend.model.AdEvent;

@Controller
public class ChartController {

    private final RestTemplate restTemplate;

    @Value("${backend.api.url}")
    private String backendUrl;

    public ChartController(RestTemplateBuilder builder) {
        this.restTemplate = builder.build();
    }

    @GetMapping("/chart")
    public String showChart(Model model) {
        try {
            // Get base URL by removing the specific endpoint
            String baseUrl = backendUrl.replace("/api/events", "");
            
            // Get event type counts
            ResponseEntity<Map<String, Long>> eventTypeResponse = restTemplate.exchange(
                baseUrl + "/api/events/counts",
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<Map<String, Long>>() {}
            );
            Map<String, Long> eventTypeCounts = eventTypeResponse.getBody();

            // Get ad performance data
            ResponseEntity<Map<String, Long>> adPerformanceResponse = restTemplate.exchange(
                baseUrl + "/api/events/top-ads",
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<Map<String, Long>>() {}
            );
            Map<String, Long> topAds = adPerformanceResponse.getBody();

            // Get detailed analytics by ad
            ResponseEntity<Map<String, Map<String, Long>>> analyticsResponse = restTemplate.exchange(
                baseUrl + "/api/events/analytics/by-ad",
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<Map<String, Map<String, Long>>>() {}
            );
            Map<String, Map<String, Long>> adAnalytics = analyticsResponse.getBody();

            model.addAttribute("eventTypeLabels", eventTypeCounts != null ? eventTypeCounts.keySet() : java.util.Collections.emptySet());
            model.addAttribute("eventTypeData", eventTypeCounts != null ? eventTypeCounts.values() : java.util.Collections.emptyList());
            model.addAttribute("topAdLabels", topAds != null ? topAds.keySet() : java.util.Collections.emptySet());
            model.addAttribute("topAdData", topAds != null ? topAds.values() : java.util.Collections.emptyList());
            model.addAttribute("adAnalytics", adAnalytics != null ? adAnalytics : java.util.Collections.emptyMap());

            return "chart";
        } catch (Exception e) {
            // Log the error and provide empty data
            System.err.println("Error fetching analytics data: " + e.getMessage());
            e.printStackTrace();
            
            model.addAttribute("eventTypeLabels", java.util.Collections.emptySet());
            model.addAttribute("eventTypeData", java.util.Collections.emptyList());
            model.addAttribute("topAdLabels", java.util.Collections.emptySet());
            model.addAttribute("topAdData", java.util.Collections.emptyList());
            model.addAttribute("adAnalytics", java.util.Collections.emptyMap());
            
            return "chart";
        }
    }

    @GetMapping("/data")
    public String showRawEvents(Model model) {
        ResponseEntity<AdEvent[]> response = restTemplate.getForEntity(backendUrl, AdEvent[].class);
        AdEvent[] events = response.getBody();
        model.addAttribute("events", Arrays.asList(events));
        return "data";
    }
}
