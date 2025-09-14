package com.taramtech.taram_event.dto;

import java.math.BigDecimal;

import com.taramtech.domain.tables.pojos.TicketTypes;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TicketTypeDTO {

    private int id;
    private String name;
    private BigDecimal price;
    private int count;
    private Integer EventId;

    /**
     * Converts this DTO to a database POJO.
     * This is used when creating or updating ticket types in the database.
     *
     * @return The TicketTypes POJO.
     */
    public TicketTypes toPojo() {
        TicketTypes pojo = new TicketTypes();
        // pojo.setId(this.id);
        pojo.setName(this.name);
        pojo.setPrice(this.price);
        pojo.setTotalCount(this.count);
        pojo.setEventId(this.EventId);
        // We set available_count to be the same as total_count on creation.
        // This will be decremented as tickets are sold.
        pojo.setAvailableCount(this.count);
        return pojo;
    }

    /**
     * Creates a DTO from a database POJO.
     * This is used when retrieving ticket type information from the database
     * to display on a web page or in an API response.
     *
     * @param pojo The TicketTypes POJO.
     * @return The populated TicketTypeDTO.
     */
    public static TicketTypeDTO fromPojo(TicketTypes pojo) {
        if (pojo == null) {
            return null;
        }
        TicketTypeDTO dto = new TicketTypeDTO();
        dto.setId(pojo.getId());
        dto.setName(pojo.getName());
        dto.setPrice(pojo.getPrice());
        dto.setCount(pojo.getTotalCount());
        return dto;
    }
}