@import java.util.Map
@import java.util.List
@import com.taramtech.taram_event.dto.EventDTO

@param Map<String, String> alerts
@param List<EventDTO> events
@param String currentPage

@template.layout.base(
    title = "Accueil", 
    alerts = alerts,
    currentPage = currentPage,
    content = @`
    <div class="row text-center mb-5">
        <div class="col-12">
            <h1 class="display-4 fw-bold">Découvrez les Évènements</h1>
            <p class="lead text-muted">Trouvez des évènements près de chez vous. </p>
        </div>
    </div>
    
    <div class="row">
        @if(events != null && !events.isEmpty())
            <div class="col-12">
                <h2 class="mb-4">Évènements en vedette</h2>
            </div>
            @for(EventDTO event : events)
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src="${event.getImageUrl()}" class="card-img-top" alt="${event.getTitle()}" style="height: 200px; object-fit: cover;">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title fw-bold">${event.getTitle()}</h5>
                            <p class="card-text text-muted flex-grow-1">${event.getDescription()}</p>
                            <a href="/events/${event.getId()}" class="btn btn-primary mt-auto">Voir les détails</a>
                        </div>
                    </div>
                </div>
            @endfor
        @else
            <div class="col-12 text-center">
                <div class="alert alert-info" role="alert">
                    Aucun évènement n'est disponible pour le moment.
                </div>
                <a href="/events/create" class="btn btn-success btn-lg">Créer un évènement</a>
            </div>
        @endif
    </div>
`)