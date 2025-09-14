@import java.util.Map
@import java.util.List
@import com.taramtech.taram_event.dto.CreateUserDTO
@import com.taramtech.taram_event.dto.RoleDTO

@param Map<String, String> alerts
@param List<RoleDTO> roles
@param CreateUserDTO user


@template.layout.base_auth(
    title = "Inscription",
    alerts = alerts,
    content = @`
    <div class="row justify-content-center align-items-center" style="min-height: 70vh;">
        <div class="col-md-6 col-lg-5">
            <h2 class="text-center mb-4">Créer un compte</h2>
            <form method="post" action="/register" class="card p-4 shadow-sm rounded-3">
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" name="lastname" id="lastname" placeholder="Nom de famille" required>
                    <label for="lastname">Nom de famille</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" name="firstname" id="firstname" placeholder="Prénom" required>
                    <label for="firstname">Prénom</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="email" class="form-control" name="email" id="email" placeholder="Email" required>
                    <label for="email">Email</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="tel" class="form-control" name="phone_number" id="phone_number" placeholder="Numero de téléphone" required>
                    <label for="phone_number">Numéro de téléphone</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="password" class="form-control" name="password" id="password" placeholder="Mot de passe" required>
                    <label for="password">Mot de passe</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="password" class="form-control" name="confirm_password" id="confirm_password" placeholder="Confirmer le mot de passe" required>
                    <label for="confirm_password">Confirmer le mot de passe</label>
                </div>
                <div class="form-floating mb-3">
                    <select class="form-select" id="role" name="role" required>
                        <option value="" selected>Choisissez votre rôle</option>
                        <option value="participant">Participant</option>
                        <option value="organizer">Organisateur</option>
                        <%-- @for(var role : roles)
                            <option value="${role.getCode()}"> ${role.getName()} </option>
                        @endfor --%>
                    </select>
                    <label for="role">Je suis un(e)</label>
                </div>
                <button type="submit" class="btn btn-success w-100 py-2">S’inscrire</button>
            </form>
            <p class="mt-3 text-center">
                Déjà un compte ? <a href="/login">Se connecter</a>
            </p>
        </div>
    </div>
`)