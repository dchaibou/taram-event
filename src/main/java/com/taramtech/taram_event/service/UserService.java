package com.taramtech.taram_event.service;

import static com.taramtech.domain.tables.User.USER;
import static com.taramtech.domain.tables.VUser.V_USER;

import java.util.Optional;

import org.jooq.Condition;
import org.jooq.DSLContext;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.taramtech.domain.tables.pojos.User;
import com.taramtech.domain.tables.pojos.VUser;
import com.taramtech.taram_event.dto.CreateUserDTO;
import com.taramtech.taram_event.dto.CustomUserDetails;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserService implements UserDetailsService {

    private final DSLContext dsl;
    private final PasswordEncoder passwordEncoder;

    public void registerUser(CreateUserDTO request) {
        if (request.getPassword().equals(request.getConfirmPassword())) {
            throw new IllegalArgumentException("Les deux mots de psse ne sont pas identiques");
        }
        if (findByEmail(request.getEmail()).isPresent()) {
            throw new IllegalArgumentException("L'email saisi est déjà utilisé");
        }
        if (findByPhoneNumber(request.getPhoneNumber()).isPresent()) {
            throw new IllegalArgumentException("Le numéro saisi est déjà utilisé");
        }
        User newUser = new User();
        newUser.setFirstname(request.getFirstname());
        newUser.setLastname(request.getLastname());
        newUser.setEmail(request.getEmail());
        newUser.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        newUser.setPhone(request.getPhoneNumber());
        newUser.setRoleCode(request.getRole());

        log.info("{}", newUser);

        dsl.insertInto(USER)
                .set(dsl.newRecord(USER, newUser))
                .execute();
    }

    public Optional<VUser> findByEmail(String email) {
        Condition condition = V_USER.EMAIL.eq(email);
        return findOne(condition);
    }

    public Optional<VUser> findByPhoneNumber(String username) {
        Condition condition = V_USER.PHONE.eq(username);
        return findOne(condition);
    }

    private Optional<VUser> findOne(Condition condition) {
        log.info("Condition : {}", condition);

        if (null == condition) {
            return Optional.empty();
        }

        return dsl.selectFrom(V_USER)
                .where(condition)
                .fetchOptionalInto(VUser.class);
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Optional<VUser> userOpt = findByEmail(username);
        if (userOpt.isPresent()) {
            return new CustomUserDetails(userOpt.get());
        } else {
            throw new UsernameNotFoundException("Utilisateur non trouvé avec le nom d'utilisateur : " + username);
        }
    }

}
