@import java.util.Map
@import com.taramtech.taram_event.dto.CustomUserDetails;

@param Map<String, String> alerts
@param CustomUserDetails user


@template.layout.base(
    title = "Dashboard", 
    currentPage = "dashboard",
    alerts = alerts,
    user = user,
    content = @`
    <div class="row justify-content-center">
        <div class="col-md-8 text-center">
            <h1 class="display-4">Bienvenue ${user.getFirstname()}</h1>
            <p class="lead">Ceci est la page d’accueil avec Spring Boot + JTE + Bootstrap.</p>
            <a href="/events" class="btn btn-primary btn-lg">Consulter les évènements</a>
        </div>
    </div>   
`)
