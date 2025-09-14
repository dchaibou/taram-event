@import com.taramtech.taram_event.config.Constants
@import java.util.Map
@import gg.jte.Content

@param String title
@param Content content
@param Map<String, String> alerts

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    <link href="/assets/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
    <style>
      html, body {
        height: 100%;
        margin: 0;
      }
      body {
        display: flex;
        flex-direction: column;
      }
      main {
        flex: 1; /* occupe tout l’espace restant entre navbar et footer */
      }
    </style>
</head>
<body>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
      <a class="navbar-brand" href="/">${Constants.APP_NAME}</a>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item"><a class="nav-link" href="/login">Connexion</a></li>
          <li class="nav-item"><a class="nav-link" href="/register">Inscription</a></li>
        </ul>
      </div>
    </div>
  </nav>

  <div class="container-fluid mt-3">
    @if(alerts != null) 
      @for(Map.Entry<String, String> entry : alerts.entrySet()) 
          <div class="alert alert-${entry.getKey()}" role="alert">
            ${entry.getValue()}
          </div>
      @endfor
    @endif
  </div>

  <main class="container-fluid mt-4">
    ${content}
  </main>

  <footer class="bg-dark text-white text-center py-3 mt-5">
    <p>&copy; 2025 - ${Constants.APP_NAME} by <a href="/" class="text-white text-decoration-none">Taram Tech</a></p>
  </footer>

  <script src="/assets/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>