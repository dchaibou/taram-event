package com.taramtech.taram_event.dto;

import com.taramtech.domain.tables.pojos.Role;

import lombok.Data;

@Data
public class RoleDTO {
    private String code;
    private String name;

    public static RoleDTO fromPojo(Role pojo) {

        if (pojo == null)
            return null;

        RoleDTO dto = new RoleDTO();
        dto.setCode(pojo.getCode());
        dto.setName(pojo.getName());
        return dto;
    }
}
