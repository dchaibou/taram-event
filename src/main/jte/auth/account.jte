@import java.util.Map
@import com.taramtech.taram_event.dto.CustomUserDetails
@import java.time.format.DateTimeFormatter

@param Map<String, String> alerts
@param CustomUserDetails user

@template.layout.base(
    title = "Mon compte",
    currentPage = "eventDetails",
    alerts = alerts,
    user = user,
    content = @`
    <div class="p-5 bg-light rounded-3 shadow">
        <h1 class="display-4">Détails de mon compte</h1>
        <p class="lead">Bienvenue sur votre espace puserersonnel. Voici les informations de votre profil :</p>
        <hr class="my-4">
        
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label fw-bold">Nom complet</label>
                <p class="form-control-plaintext">${user.getFirstname()} ${user.getLastname()}</p>
            </div>
            <div class="col-md-6">
                <label class="form-label fw-bold">Adresse e-mail</label>
                <p class="form-control-plaintext">${user.getEmail()} (@if(user.getEmailVerified() != null && user.getEmailVerified()) Verifié @else Non verifié @endif)</p>
            </div>
            <div class="col-md-6">
                <label class="form-label fw-bold">Rôle</label>
                <p class="form-control-plaintext">${user.getRoleName()} </p>
            </div>
            <div class="col-md-6">
                <label class="form-label fw-bold">Numero de telephone</label>
                <p class="form-control-plaintext">${user.getPhone()} (@if(user.getPhoneVerified() != null && user.getPhoneVerified()) Verifié @else Non verifié @endif)</p>
            </div>
            <div class="col-md-6">
                <label class="form-label fw-bold">Créé le</label>
                @if(user.getCreatedAt() != null)
                <p class="form-control-plaintext">${user.getCreatedAt().format(DateTimeFormatter.ofPattern("dd MMMM yyyy 'à' HH:mm"))}</p>
                @endif
            </div>
        </div>
    </div>
`)
