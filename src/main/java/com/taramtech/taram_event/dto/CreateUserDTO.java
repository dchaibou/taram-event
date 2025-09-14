package com.taramtech.taram_event.dto;

import lombok.Data;

@Data
public class CreateUserDTO {
    private String lastname;
    private String firstname;
    private String email;
    private String phoneNumber;
    private String password;
    private String confirmPassword;
    private String role;
}