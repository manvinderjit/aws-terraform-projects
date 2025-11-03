package com.example.backend.controller;

import com.example.backend.entity.AdEvent;
import com.example.backend.repository.AdEventRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.LinkedHashMap;

@RestController
public class AdEventController {

    private final AdEventRepository repository;

    public AdEventController(AdEventRepository repository) {
        this.repository = repository;
    }

    // Return all events (for testing or detailed view)
    @GetMapping("/api/events")
    public List<AdEvent> getAllEvents() {
        return repository.findAll();
    }

    // Return counts of events by type (for charts)
    @GetMapping("/api/events/counts")
    public Map<String, Long> getEventCounts() {
        return repository.findAll()
                .stream()
                .collect(Collectors.groupingBy(AdEvent::getEventType, Collectors.counting()));
    }

    // Return counts of events by ad title
    @GetMapping("/api/events/counts/by-ad")
    public Map<String, Long> getEventCountsByAd() {
        return repository.findAll()
                .stream()
                .filter(event -> event.getAdTitle() != null)
                .collect(Collectors.groupingBy(AdEvent::getAdTitle, Collectors.counting()));
    }

    // Return detailed analytics by ad (events breakdown per ad)
    @GetMapping("/api/events/analytics/by-ad")
    public Map<String, Map<String, Long>> getAnalyticsByAd() {
        return repository.findAll()
                .stream()
                .filter(event -> event.getAdTitle() != null)
                .collect(Collectors.groupingBy(
                    AdEvent::getAdTitle,
                    LinkedHashMap::new,
                    Collectors.groupingBy(AdEvent::getEventType, Collectors.counting())
                ));
    }

    // Return top performing ads by total interactions
    @GetMapping("/api/events/top-ads")
    public Map<String, Long> getTopAds() {
        return repository.findAll()
                .stream()
                .filter(event -> event.getAdTitle() != null)
                .collect(Collectors.groupingBy(AdEvent::getAdTitle, Collectors.counting()))
                .entrySet()
                .stream()
                .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                .limit(10)
                .collect(Collectors.toMap(
                    Map.Entry::getKey,
                    Map.Entry::getValue,
                    (e1, e2) -> e1,
                    LinkedHashMap::new
                ));
    }
}
