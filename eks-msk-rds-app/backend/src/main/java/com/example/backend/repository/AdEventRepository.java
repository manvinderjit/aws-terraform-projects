package com.example.backend.repository;

import com.example.backend.entity.AdEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdEventRepository extends JpaRepository<AdEvent, Long> {
}
