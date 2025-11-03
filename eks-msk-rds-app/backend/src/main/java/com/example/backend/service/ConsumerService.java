package com.example.backend.service;

import com.example.backend.entity.AdEvent;
import com.example.backend.repository.AdEventRepository;
import org.json.JSONObject;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
public class ConsumerService {

    private final AdEventRepository repository;

    public ConsumerService(AdEventRepository repository) {
        this.repository = repository;
    }

    @KafkaListener(topics = {"ad_viewed", "ad_clicked", "ad_closed"}, groupId = "ad-consumer-group")
    public void consume(String message, @Header(KafkaHeaders.RECEIVED_TOPIC) String topic) {
        try {
            JSONObject json = new JSONObject(message);
            String eventType = json.getString("eventType");
            Instant timestamp = Instant.parse(json.getString("timestamp"));

            AdEvent event = new AdEvent();
            event.setEventType(eventType);
            event.setTimestamp(timestamp);

            // Handle optional ad information
            if (json.has("adId")) {
                event.setAdId(json.getLong("adId"));
            }
            if (json.has("adTitle")) {
                event.setAdTitle(json.getString("adTitle"));
            }
            if (json.has("adCompany")) {
                event.setAdCompany(json.getString("adCompany"));
            }
            if (json.has("adCategory")) {
                event.setAdCategory(json.getString("adCategory"));
            }

            repository.save(event);
            System.out.printf("Saved event from topic [%s]: %s%n", topic, message);
        } catch (Exception e) {
            System.err.printf("Failed to process message from topic [%s]: %s, error: %s%n", topic, message, e.getMessage());
        }
    }
}
