@import com.taramtech.taram_event.config.Constants
@import java.util.Map
@import gg.jte.Content

@param String title
@param Content content
@param Map<String, String> alerts
@param String currentPage

<!DOCTYPE html>
<html lang="fr" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} | ${Constants.APP_NAME}</title>
    <link href="/assets/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="/assets/bootstrap-icons/1.11.0/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
<style>
  :root {
    --navbar-height: 60px;
    --sidebar-width: 250px;
    --sidebar-collapsed-width: 70px;
  }
  body {
    font-family: 'Poppins', sans-serif;
    background-color: #f8f9fa;
    /* Empêche le défilement horizontal */
    overflow-x: hidden; 
  }
  #sidebar {
    width: var(--sidebar-width);
    height: calc(100vh - var(--navbar-height));
    transition: all 0.3s ease;
    position: fixed;
    left: 0;
    top: var(--navbar-height);
    z-index: 1030;
    overflow-y: auto;
    /* Masquer la barre latérale par défaut sur mobile */
    transform: translateX(0);
  }
  #sidebar.collapsed {
    width: var(--sidebar-collapsed-width);
  }
  #sidebar .nav-link {
    white-space: nowrap;
    padding: 1rem;
    transition: background-color 0.2s, color 0.2s;
    border-left: 5px solid transparent;
  }
  #sidebar .nav-link:hover {
    background-color: #e2e6ea;
  }
  #sidebar .nav-link.active {
    background-color: #e9ecef;
    color: var(--bs-primary) !important;
    font-weight: 500;
    border-left: 5px solid var(--bs-primary);
  }
  #sidebar .nav-link span {
    overflow: hidden;
    text-overflow: ellipsis;
  }
  
  #sidebar.collapsed .nav-link span, 
  #sidebar.collapsed .nav-item .collapse {
    display: none;
  }
  #sidebar.collapsed .nav-link {
    text-align: center;
    padding-left: 0.5rem;
    padding-right: 0.5rem;
  }
  #sidebar.collapsed .nav-link i {
    margin-right: 0 !important;
  }
  main {
    min-height: calc(100vh - var(--navbar-height));
    margin-left: var(--sidebar-width);
    transition: margin-left 0.3s ease;
    padding-bottom: 5rem;
  }
  footer {
    height: 5rem;
    width: 100%;
  }
  .main-footer-container {
    margin-left: var(--sidebar-width);
    transition: margin-left 0.3s ease;
  }
  #sidebar.collapsed ~ main,
  #sidebar.collapsed ~ .main-footer-container {
    margin-left: var(--sidebar-collapsed-width);
  }
  .logo-brand {
    font-weight: 600;
    font-size: 1.5rem;
  }
  
  /* MEDIA QUERY POUR LES APPAREILS MOBILES */
  @media (max-width: 768px) {
    #sidebar {
      /* Masque la barre latérale en la décalant hors de l'écran */
      transform: translateX(-100%);
    }
    #sidebar.show {
      /* Affiche la barre latérale en la repositionnant */
      transform: translateX(0);
    }
    main, .main-footer-container {
      /* Supprime la marge de la barre latérale sur mobile */
      margin-left: 0 !important;
      padding: 1rem; /* Espace pour le contenu */
    }
    #sidebar.collapsed {
        /* Gère le cas où la barre latérale est "miniaturisée" sur mobile */
        width: var(--sidebar-width);
    }
    #sidebar.collapsed .nav-link span, 
    #sidebar.collapsed .nav-item .collapse {
        display: inline;
    }
    #sidebar.collapsed .nav-link i {
        margin-right: 0.5rem !important;
    }
  }
</style>
</head>
<body>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm" style="height: var(--navbar-height);">
    <div class="container-fluid">
      <div class="d-flex align-items-center">
        <button class="btn btn-dark me-3" id="sidebarToggle" aria-label="Toggle sidebar">
          <i class="bi bi-list"></i>
        </button>
        <a class="navbar-brand fw-bold logo-brand" href="/">${Constants.APP_NAME}</a>
      </div>

       <div class="d-flex align-items-center ms-auto">
          <a class="d-flex align-items-center text-white text-decoration-none me-3" href="/account" aria-label="Mon compte">
              <i class="bi bi-person-circle"></i>
              <span class="d-none d-md-inline ms-2">Mon compte</span>
          </a>
          <a class="btn btn-danger d-flex align-items-center" href="/auth/logout" aria-label="Déconnexion">
              <i class="bi bi-box-arrow-right"></i>
              <span class="d-none d-md-inline ms-2">Déconnexion</span>
          </a>
      </div>
      <%-- <div class="d-flex align-items-center ms-auto">
        <a class="d-flex align-items-center" href="/account" aria-label="Mon compte">
          <i class="bi bi-box-arrow-left"></i>
          <span class="d-none d-md-inline ms-2">Mon compte</span>
        </a>
        <a class="btn btn-danger d-flex align-items-center" href="/logout" aria-label="Déconnexion">
          <i class="bi bi-box-arrow-left"></i>
          <span class="d-none d-md-inline ms-2">Déconnexion</span>
        </a>
      </div> --%>
    </div>
  </nav>

  <aside id="sidebar" class="bg-white border-end shadow-sm">
    <div class="p-4 d-flex align-items-center">
      <h5 class="m-0 text-primary">Menu</h5>
    </div>
    <ul class="nav flex-column">
      <li class="nav-item">
        <a href="/dashboard" class="nav-link text-dark d-flex align-items-center ${currentPage.equals("dashboard") ? "active" : ""}">
          <i class="bi bi-house me-2"></i>
          <span>Tableau de bord</span>
        </a>
      </li>
      
       <li class="nav-item">
        <a href="#" class="nav-link text-dark d-flex align-items-center" data-bs-toggle="collapse" data-bs-target="#events-collapse" aria-expanded="${currentPage.startsWith("events") ? "true" : "false"}" aria-controls="events-collapse">
          <i class="bi bi-calendar-check me-2"></i>
          <span>Évènements</span>
          <i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <div class="collapse ${currentPage.startsWith("events") ? "show" : ""}" id="events-collapse">
          <ul class="nav flex-column ps-4">
            <li class="nav-item">
              <a href="/events/create" class="nav-link text-dark ${currentPage.equals("eventForm") ? "active" : ""}">Créer un évènement</a>
            </li>
            <li class="nav-item">
              <a href="/events/eventPeriod/today" class="nav-link text-dark ${currentPage.equals("eventsToday") ? "active" : ""}">Évènements du jour</a>
            </li>
            <li class="nav-item">
              <a href="/events/eventPeriod/week" class="nav-link text-dark ${currentPage.equals("eventsWeek") ? "active" : ""}">Évènements de la semaine</a>
            </li>
            <li class="nav-item">
              <a href="/events/eventPeriod/month" class="nav-link text-dark ${currentPage.equals("eventsMonth") ? "active" : ""}">Évènements du mois</a>
            </li>      
            <li class="nav-item">
              <a href="/events/eventPeriod/all" class="nav-link text-dark ${currentPage.equals("events") ? "active" : ""}">Tous les évènements</a>
            </li>                                    
          </ul>
        </div>
      </li>

      <li class="nav-item">
        <a href="#" class="nav-link text-dark d-flex align-items-center" data-bs-toggle="collapse" data-bs-target="#users-collapse" aria-expanded="${currentPage.startsWith("users") ? "true" : "false"}" aria-controls="users-collapse">
          <i class="bi bi-people me-2"></i>
          <span>Utilisateurs</span>
          <i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <div class="collapse ${currentPage.startsWith("users") ? "show" : ""}" id="users-collapse">
          <ul class="nav flex-column ps-4">
            <li class="nav-item">
              <a href="/users" class="nav-link text-dark ${currentPage.equals("usersAll") ? "active" : ""}">Tous les utilisateurs</a>
            </li>
            <li class="nav-item">
              <a href="/roles" class="nav-link text-dark ${currentPage.equals("roles") ? "active" : ""}">Rôles</a>
            </li>
          </ul>
        </div>
      </li>
    </ul>
  </aside>

  <main class="p-4">
    @if(alerts != null && !alerts.isEmpty())
      @for(Map.Entry<String, String> entry : alerts.entrySet())
          <div class="alert alert-${entry.getKey()}">${entry.getValue()}</div>
      @endfor
    @endif
    ${content}
  </main>

  <div class="main-footer-container">
    <footer class="bg-white text-dark text-center py-3 border-top">
      <p class="mb-0">&copy; 2025 - ${Constants.APP_NAME}</p>
      <p class="mb-0">Powered by <a href="https://www.taramtech.com" class="text-primary text-decoration-none fw-bold">Taram Tech</a></p>
    </footer>
  </div>

  <script src="/assets/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
  <script>
    const sidebar = document.getElementById("sidebar");
    const mainContent = document.querySelector("main");
    const footerContainer = document.querySelector(".main-footer-container");
    const toggle = document.getElementById("sidebarToggle");

    function updateLayout(isCollapsed) {
        const sidebarWidth = isCollapsed ? 'var(--sidebar-collapsed-width)' : 'var(--sidebar-width)';

        // Appliquer les marges uniquement sur les grands écrans
        if (window.innerWidth >= 768) {
            mainContent.style.marginLeft = sidebarWidth;
            footerContainer.style.marginLeft = sidebarWidth;
        } else {
            mainContent.style.marginLeft = '0';
            footerContainer.style.marginLeft = '0';
        }

        localStorage.setItem('sidebarCollapsed', isCollapsed);
    }

    function handleSidebarToggle() {
      if (window.innerWidth < 768) {
        // Sur mobile, bascule la classe 'show'
        sidebar.classList.toggle("show");
      } else {
        // Sur bureau, bascule la classe 'collapsed'
        sidebar.classList.toggle("collapsed");
        updateLayout(sidebar.classList.contains("collapsed"));
      }
    }

    if (toggle) {
      toggle.addEventListener("click", handleSidebarToggle);
    }

    window.addEventListener('resize', () => {
        if (window.innerWidth >= 768) {
            const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
            sidebar.classList.toggle("collapsed", isCollapsed);
            sidebar.classList.remove("show");
            updateLayout(isCollapsed);
        } else {
            sidebar.classList.remove("collapsed");
            updateLayout(false);
        }
    });

    document.addEventListener('DOMContentLoaded', () => {
        if (window.innerWidth >= 768) {
            const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
            sidebar.classList.toggle("collapsed", isCollapsed);
            updateLayout(isCollapsed);
        }
    });
</script>
</body>
</html>