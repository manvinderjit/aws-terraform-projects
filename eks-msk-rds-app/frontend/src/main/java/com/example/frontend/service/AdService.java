package com.example.frontend.service;

import com.example.frontend.model.Ad;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.Random;

@Service
public class AdService {
    
    private final List<Ad> sampleAds;
    private final Random random = new Random();

    public AdService() {
        // Initialize with sample ads
        this.sampleAds = Arrays.asList(
            new Ad(1L, "Premium Coffee Beans", "Discover the world's finest coffee beans, roasted to perfection", 
                   "https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop", 
                   "https://example.com/coffee", "BrewMaster Co.", "Food & Beverage"),
            
            new Ad(2L, "Latest Smartphone", "Experience cutting-edge technology with our newest smartphone model", 
                   "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=200&fit=crop", 
                   "https://example.com/phone", "TechCorp", "Electronics"),
            
            new Ad(3L, "Luxury Watch Collection", "Timeless elegance meets modern craftsmanship", 
                   "https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=300&h=200&fit=crop", 
                   "https://example.com/watches", "TimeKeeper", "Fashion"),
            
            new Ad(4L, "Fitness Tracker Pro", "Track your health and fitness goals with precision", 
                   "https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=300&h=200&fit=crop", 
                   "https://example.com/fitness", "HealthTech", "Health & Fitness"),
            
            new Ad(5L, "Organic Skincare Set", "Natural ingredients for radiant, healthy skin", 
                   "https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=300&h=200&fit=crop", 
                   "https://example.com/skincare", "NaturalGlow", "Beauty"),
            
            new Ad(6L, "Gaming Laptop", "Ultimate performance for serious gamers", 
                   "https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=300&h=200&fit=crop", 
                   "https://example.com/gaming", "GameForce", "Electronics"),
            
            new Ad(7L, "Travel Backpack", "Adventure-ready backpack for all your journeys", 
                   "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&h=200&fit=crop", 
                   "https://example.com/backpack", "AdventureGear", "Travel"),
            
            new Ad(8L, "Wireless Headphones", "Immersive sound quality with noise cancellation", 
                   "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=200&fit=crop", 
                   "https://example.com/headphones", "AudioMax", "Electronics")
        );
    }

    public List<Ad> getAllAds() {
        return sampleAds;
    }

    public Ad getRandomAd() {
        return sampleAds.get(random.nextInt(sampleAds.size()));
    }

    public Ad getAdById(Long id) {
        return sampleAds.stream()
                .filter(ad -> ad.getId().equals(id))
                .findFirst()
                .orElse(getRandomAd());
    }
}