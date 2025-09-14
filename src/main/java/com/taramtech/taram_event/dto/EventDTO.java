package com.taramtech.taram_event.dto;

import com.taramtech.domain.tables.pojos.Event;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EventDTO {

    private Integer id;
    private String title;
    private String eventType;
    private String description;
    private String location;
    private LocalDateTime eventDate;
    private String imageUrl;
    private List<TicketTypeDTO> tickets;

    public Event toPojo() {
        Event pojo = new Event();
        pojo.setId(this.id);
        pojo.setTitle(this.title);
        pojo.setDescription(this.description);
        pojo.setLocation(this.location);
        pojo.setEventDate(this.eventDate);
        pojo.setImageUrl(this.imageUrl);
        return pojo;
    }

    public static EventDTO fromPojo(Event pojo) {
        if (pojo == null) {
            return null;
        }
        EventDTO dto = new EventDTO();
        dto.setId(pojo.getId());
        dto.setTitle(pojo.getTitle());
        dto.setDescription(pojo.getDescription());
        dto.setLocation(pojo.getLocation());
        dto.setEventDate(pojo.getEventDate());
        dto.setImageUrl(pojo.getImageUrl());
        return dto;
    }
}