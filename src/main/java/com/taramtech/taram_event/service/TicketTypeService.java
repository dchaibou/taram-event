package com.taramtech.taram_event.service;

import com.taramtech.domain.tables.pojos.TicketTypes;
import com.taramtech.taram_event.dto.TicketTypeDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jooq.DSLContext;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

import static com.taramtech.domain.tables.TicketTypes.TICKET_TYPES;

@Service
@Slf4j
@RequiredArgsConstructor
public class TicketTypeService {

    private final DSLContext dsl;

    public TicketTypeDTO create(TicketTypeDTO ticketType) {
        TicketTypes pojo = ticketType.toPojo();
        TicketTypes result = dsl.insertInto(TICKET_TYPES)
                .set(dsl.newRecord(TICKET_TYPES, pojo))
                .returning()
                .fetchOneInto(TicketTypes.class);
        return TicketTypeDTO.fromPojo(result);
    }

    public TicketTypeDTO update(TicketTypeDTO ticketType) {
        TicketTypes pojo = ticketType.toPojo();
        dsl.update(TICKET_TYPES)
                .set(dsl.newRecord(TICKET_TYPES, pojo))
                .where(TICKET_TYPES.ID.eq(pojo.getId()))
                .execute();

        return findById(pojo.getId()).map(TicketTypeDTO::fromPojo).orElse(null);
    }

    public List<TicketTypeDTO> findAll(int eventId) {
        return dsl.select()
                .from(TICKET_TYPES)
                .where(TICKET_TYPES.EVENT_ID.eq(eventId))
                .fetchInto(TicketTypes.class)
                .stream()
                .map(TicketTypeDTO::fromPojo)
                .toList();
    }

    public boolean delete(int ticketTypeId) {
        return dsl.deleteFrom(TICKET_TYPES)
                .where(TICKET_TYPES.ID.eq(ticketTypeId))
                .execute() > 0;
    }

    public boolean deleteAll(int eventId) {
        return dsl.deleteFrom(TICKET_TYPES)
                .where(TICKET_TYPES.EVENT_ID.eq(eventId))
                .execute() > 0;
    }

    private Optional<TicketTypes> findById(int id) {
        return dsl.select()
                .from(TICKET_TYPES)
                .where(TICKET_TYPES.ID.eq(id))
                .fetchOptionalInto(TicketTypes.class);
    }
}