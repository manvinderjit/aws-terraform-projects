package com.example.backend.service;

import jakarta.annotation.PostConstruct;
import org.apache.kafka.clients.admin.AdminClient;
import org.apache.kafka.clients.admin.AdminClientConfig;
import org.apache.kafka.clients.admin.CreateTopicsResult;
import org.apache.kafka.clients.admin.ListTopicsResult;
import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

@Service
public class KafkaAdminService {

    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    private final List<String> requiredTopics = List.of("ad_viewed", "ad_clicked", "ad_closed");

    @PostConstruct
    public void createTopicsIfNotExist() throws ExecutionException, InterruptedException {
        Properties config = new Properties();
        config.put(AdminClientConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);

        try (AdminClient adminClient = AdminClient.create(config)) {

            // Get existing topics
            ListTopicsResult listTopicsResult = adminClient.listTopics();
            Set<String> existingTopics = listTopicsResult.names().get();

            // Filter topics that don't exist
            List<NewTopic> topicsToCreate = requiredTopics.stream()
                    .filter(topic -> !existingTopics.contains(topic))
                    .map(topic -> new NewTopic(topic, 1, (short) 1)) 
                    .collect(Collectors.toList());

            if (!topicsToCreate.isEmpty()) {
                CreateTopicsResult result = adminClient.createTopics(topicsToCreate);
                result.all().get();  // Wait for creation
                System.out.println("Created topics: " + topicsToCreate.stream().map(NewTopic::name).collect(Collectors.joining(", ")));
            } else {
                System.out.println("All required topics already exist.");
            }
        }
    }
}
