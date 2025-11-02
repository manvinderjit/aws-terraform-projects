package com.example.frontend.service;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
public class ProducerService {

    private final KafkaTemplate<String, String> kafkaTemplate;

    public ProducerService(KafkaTemplate<String, String> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }    

    public void sendEvent(String eventType) {
        sendEvent(eventType, null, null);
    }

    public void sendEvent(String eventType, Long adId, String adTitle) {
        sendEvent(eventType, adId, adTitle, null, null);
    }

    public void sendEvent(String eventType, Long adId, String adTitle, String adCompany, String adCategory) {
        String topic = switch (eventType) {
            case "ad_viewed" -> "ad_viewed";
            case "ad_clicked" -> "ad_clicked";
            case "ad_closed" -> "ad_closed";
            default -> throw new IllegalArgumentException("Unknown event type: " + eventType);
        };

        String eventJson;
        if (adId != null && adTitle != null) {
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("{\"eventType\":\"").append(eventType).append("\"");
            jsonBuilder.append(", \"timestamp\":\"").append(Instant.now().toString()).append("\"");
            jsonBuilder.append(", \"adId\":").append(adId);
            jsonBuilder.append(", \"adTitle\":\"").append(adTitle.replace("\"", "\\\"")).append("\"");
            
            if (adCompany != null) {
                jsonBuilder.append(", \"adCompany\":\"").append(adCompany.replace("\"", "\\\"")).append("\"");
            }
            if (adCategory != null) {
                jsonBuilder.append(", \"adCategory\":\"").append(adCategory.replace("\"", "\\\"")).append("\"");
            }
            
            jsonBuilder.append("}");
            eventJson = jsonBuilder.toString();
        } else {
            eventJson = String.format(
                    "{\"eventType\":\"%s\", \"timestamp\":\"%s\"}",
                    eventType,
                    Instant.now().toString()
            );
        }

        kafkaTemplate.send(topic, eventJson);
        System.out.println("Sent event to topic [" + topic + "]: " + eventJson);
    }
}
