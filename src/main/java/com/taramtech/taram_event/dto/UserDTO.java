package com.taramtech.taram_event.dto;

import com.taramtech.domain.tables.pojos.VUser;

import lombok.Data;

@Data
public class UserDTO {
    private String lastname;
    private String firstname;
    private String email;
    private String phoneNumber;
    private String role;

    public static UserDTO fromPojo(VUser pojo) {
        return null;
    }
}