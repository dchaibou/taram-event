package com.taramtech.taram_event.service;

import static com.taramtech.domain.tables.EventType.EVENT_TYPE;
import static com.taramtech.domain.tables.Role.ROLE;

import java.util.List;
import com.taramtech.taram_event.dto.RoleDTO;

import org.jooq.DSLContext;
import org.springframework.stereotype.Service;

import com.taramtech.domain.tables.pojos.EventType;
import com.taramtech.domain.tables.pojos.Role;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ReferentielService {
    private final DSLContext dsl;

    public List<EventType> findAllEventTypes() {
        return dsl
                .selectFrom(EVENT_TYPE)
                .orderBy(EVENT_TYPE.NAME)
                .fetchInto(EventType.class);
    }

    public List<RoleDTO> findAllRoles() {
        return dsl
                .selectFrom(ROLE)
                .orderBy(ROLE.NAME)
                .fetchInto(Role.class)
                .stream()
                .map(RoleDTO::fromPojo)
                .toList();
    }
}
