package com.taramtech.taram_event.service;

import com.taramtech.domain.tables.pojos.Event;
import com.taramtech.taram_event.dto.EventDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static com.taramtech.domain.tables.Event.EVENT;
import static com.taramtech.domain.tables.EventType.EVENT_TYPE;

@Service
@Slf4j
@RequiredArgsConstructor
public class EventService {

    private final DSLContext dsl;
    private final TicketTypeService ticketTypeService;

    public EventDTO create(EventDTO eventDTO) {
        Event pojo = eventDTO.toPojo();

        // To delete
        Integer eventTypeId = dsl.select(EVENT_TYPE.ID)
                .from(EVENT_TYPE)
                .where(EVENT_TYPE.NAME.eq(eventDTO.getEventType()))
                .fetchOneInto(Integer.class);

        if (eventTypeId == null) {
            log.warn("Event type not found for name: {}", eventDTO.getEventType());
            return null;
        }
        // To delete

        pojo.setEventTypeId(eventTypeId);
        pojo.setOrganizerId(1); // userId

        Event result = dsl.insertInto(EVENT)
                .set(dsl.newRecord(EVENT, pojo))
                .returning()
                .fetchOneInto(Event.class);

        // If ticket types are provided, save them
        if (eventDTO.getTickets() != null) {
            eventDTO.getTickets().forEach(ticketDto -> {
                ticketDto.setEventId(result.getId());
                ticketTypeService.create(ticketDto);
            });
        }

        return EventDTO.fromPojo(result);
    }

    public EventDTO update(EventDTO eventDTO) {
        Event pojo = eventDTO.toPojo();

        dsl.update(EVENT)
                .set(dsl.newRecord(EVENT, pojo))
                .where(EVENT.ID.eq(pojo.getId()))
                .execute();

        // To delete
        ticketTypeService.deleteAll(pojo.getId());
        if (eventDTO.getTickets() != null) {
            eventDTO.getTickets().forEach(ticketDto -> {
                ticketDto.setEventId(pojo.getId());
                ticketTypeService.create(ticketDto);
            });
        }
        // To delete

        // Return the updated DTO
        return findById(pojo.getId()).orElse(null);
    }

    public List<EventDTO> findAllToday() {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().plusDays(1).atStartOfDay().minusSeconds(1);

        Condition condition = EVENT.EVENT_DATE.between(startOfDay, endOfDay);
        return findAll(condition).stream().map(EventDTO::fromPojo).toList();
    }

    public List<EventDTO> findAllThisWeek() {
        LocalDateTime startOfWeek = LocalDate.now().with(java.time.DayOfWeek.MONDAY).atStartOfDay();
        LocalDateTime endOfWeek = LocalDate.now().with(java.time.DayOfWeek.SUNDAY).plusDays(1).atStartOfDay()
                .minusSeconds(1);

        Condition condition = EVENT.EVENT_DATE.between(startOfWeek, endOfWeek);
        return findAll(condition).stream().map(EventDTO::fromPojo).toList();
    }

    public List<EventDTO> findAllThisMonth() {
        LocalDateTime startOfMonth = LocalDate.now().withDayOfMonth(1).atStartOfDay();
        LocalDateTime endOfMonth = LocalDate.now().plusMonths(1).withDayOfMonth(1).atStartOfDay().minusSeconds(1);

        Condition condition = EVENT.EVENT_DATE.between(startOfMonth, endOfMonth);
        return findAll(condition).stream().map(EventDTO::fromPojo).toList();
    }

    public List<EventDTO> findAll() {
        return findAll(null).stream().map(EventDTO::fromPojo).toList();
    }

    public Optional<EventDTO> findById(int id) {
        Condition condition = EVENT.ID.eq(id);
        return findOne(condition).map(EventDTO::fromPojo);
    }

    public boolean delete(int id) {
        return dsl.deleteFrom(EVENT)
                .where(EVENT.ID.eq(id))
                .execute() > 0;
    }

    private List<Event> findAll(Condition condition) {
        return dsl.select()
                .from(EVENT)
                .where(condition)
                .orderBy(EVENT.EVENT_DATE)
                .fetchInto(Event.class);
    }

    private Optional<Event> findOne(Condition condition) {
        return dsl.select()
                .from(EVENT)
                .where(condition)
                .fetchOptionalInto(Event.class);
    }
}