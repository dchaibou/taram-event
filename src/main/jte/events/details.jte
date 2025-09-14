@import java.util.Map
@import com.taramtech.taram_event.dto.EventDTO
@import com.taramtech.taram_event.dto.TicketTypeDTO

@param Map<String, String> alerts
@param EventDTO event

@template.layout.base(
    title = event.getTitle(),
    alerts = alerts,
    currentPage = "eventDetails",
    content = @`
    <div class="row">
        <div class="col-12">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/events">Tous les événements</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${event.getTitle()}</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="row mb-5">
        <div class="col-lg-8">
            <div class="card shadow-sm mb-4">
                <img src="${event.getImageUrl()}" class="card-img-top event-details-img" alt="${event.getTitle()}">
                <div class="card-body">
                    <h1 class="card-title fw-bold display-4">${event.getTitle()}</h1>
                    <p class="text-muted">${event.getEventType()}</p>
                    <p class="lead">${event.getDescription()}</p>
                    <hr>
                    <p class="card-text">
                        <strong><i class="bi bi-geo-alt me-2"></i>Catégorie :</strong> 
                        <%-- ${event.getCategorieName()} --%>
                    </p>
                    <p class="card-text">
                        <strong><i class="bi bi-geo-alt me-2"></i>Lieu :</strong> ${event.getLocation()}
                    </p>
                    <p class="card-text">
                        <strong><i class="bi bi-calendar-event me-2"></i>Date :</strong> ${event.getEventDate().toString()}
                    </p>
                    <div class="d-flex justify-content-start mt-4">
                        <a href="/events/${event.getId()}/edit" class="btn btn-warning me-2">
                            <i class="bi bi-pencil-square me-2"></i>Modifier l'événement
                        </a>
                        <form action="/events/${event.getId()}/delete" method="post" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cet événement ?');">
                            <button type="submit" class="btn btn-danger">
                                <i class="bi bi-trash me-2"></i>Supprimer
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card shadow-sm p-4">
                <h2 class="card-title mb-4">Billets disponibles</h2>
                @if(event.getTickets() != null && !event.getTickets().isEmpty())
                    <ul class="list-group list-group-flush">
                        @for(TicketTypeDTO ticket : event.getTickets())
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="mb-1 fw-bold">${ticket.getName()}</h5>
                                    <span class="text-muted">${String.format("%.0f", ticket.getPrice())} XOF</span>
                                </div>
                                <span class="badge bg-primary rounded-pill">${ticket.getCount()}</span>
                            </li>
                        @endfor
                    </ul>
                @else
                    <div class="alert alert-info">
                        Aucun billet n'est disponible pour cet événement.
                    </div>
                @endif
            </div>
        </div>
    </div>
`)