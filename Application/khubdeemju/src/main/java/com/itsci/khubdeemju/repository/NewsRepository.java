package com.itsci.khubdeemju.repository;

import com.itsci.khubdeemju.model.News;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface NewsRepository extends JpaRepository<News, String> {

    @Transactional
    @Modifying
    @Query(value = "SELECT n FROM News n WHERE n.title LIKE %:searchtext%")
    List<News> findByTitle(@Param("searchtext") String searchtext);

}
