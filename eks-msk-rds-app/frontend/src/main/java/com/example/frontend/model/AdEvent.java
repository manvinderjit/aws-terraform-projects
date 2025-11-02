package com.example.frontend.model;

import java.time.Instant;

public class AdEvent {
    private Long id;
    private String eventType;
    private Instant timestamp;
    private Long adId;
    private String adTitle;
    private String adCompany;
    private String adCategory;

    public AdEvent() {}

    public AdEvent(Long id, String eventType, Instant timestamp, Long adId, String adTitle, String adCompany, String adCategory) {
        this.id = id;
        this.eventType = eventType;
        this.timestamp = timestamp;
        this.adId = adId;
        this.adTitle = adTitle;
        this.adCompany = adCompany;
        this.adCategory = adCategory;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public Instant getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Instant timestamp) {
        this.timestamp = timestamp;
    }

    public Long getAdId() {
        return adId;
    }

    public void setAdId(Long adId) {
        this.adId = adId;
    }

    public String getAdTitle() {
        return adTitle;
    }

    public void setAdTitle(String adTitle) {
        this.adTitle = adTitle;
    }

    public String getAdCompany() {
        return adCompany;
    }

    public void setAdCompany(String adCompany) {
        this.adCompany = adCompany;
    }

    public String getAdCategory() {
        return adCategory;
    }

    public void setAdCategory(String adCategory) {
        this.adCategory = adCategory;
    }
}
