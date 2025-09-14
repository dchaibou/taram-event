@import java.util.Map
@param Map<String, String> alerts

@template.layout.base_auth(
    title = "Connexion", 
    alerts = alerts,
    content = @`

    <div class="row justify-content-center align-items-center" style="min-height: 70vh;">
        <div class="col-md-6 col-lg-5">
            <h2 class="text-center mb-4">Connexion</h2>
            <form method="post" action="/login" class="card p-4 shadow-sm rounded-3">
                <div class="form-floating mb-3">
                    <input type="email" class="form-control" name="username" id="username" placeholder="Email" required>
                    <label for="username">Email</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="password" class="form-control" name="password" id="password" placeholder="Mot de passe" required>
                    <label for="password">Mot de passe</label>
                </div>
                <button type="submit" class="btn btn-primary w-100 py-2">Se connecter</button>
            </form>
            <p class="mt-3 text-center">
                Pas encore inscrit ? <a href="/register">Créer un compte</a>
            </p>
        </div>
    </div>

`)
