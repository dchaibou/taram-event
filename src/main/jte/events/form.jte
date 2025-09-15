@import java.util.List
@import java.util.Map
@import com.taramtech.taram_event.dto.EventDTO
@import com.taramtech.domain.tables.pojos.EventType
@import com.taramtech.taram_event.dto.CustomUserDetails

@param Map<String, String> alerts
@param EventDTO event
@param List<EventType> eventTypes
@param CustomUserDetails user

@template.layout.base(
    title = event.getId() != null ? "Modifier un événement" : "Créer un événement",
    currentPage = "eventForm",
    alerts = alerts,
    user = user,
    content = @`
    <div class="row">
        <div class="col-12">
            <h1 class="mb-4">
                @if(event.getId() != null)
                    Modifier l'événement : ${event.getTitle()}
                @else
                    Créer un nouvel événement
                @endif
            </h1>
        </div>
    </div>
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm p-4">
                <form action="/events/${event.getId() != null ? event.getId() + "/update" : "create"}" method="post" enctype="multipart/form-data" id="event-form">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="title" class="form-label fw-bold">Titre de l'événement</label>
                            <input type="text" class="form-control" id="title" name="title" value="${event.getTitle()}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="eventType" class="form-label fw-bold">Catégorie</label>
                            <select class="form-select" id="eventType" name="eventType" required>
                                <option value="" disabled selected>Choisir une catégorie</option>
                                @for(EventType type : eventTypes)
                                    @if(type.getName().equals(event.getEventType()))
                                    <option value="${type.getName()}"  selected>
                                        ${type.getName()}
                                    </option>
                                    @else
                                    <option value="${type.getName()}">
                                        ${type.getName()}
                                    </option>
                                    @endif

                                @endfor
                            </select>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label fw-bold">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="5" required>${event.getDescription()}</textarea>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="location" class="form-label fw-bold">Lieu</label>
                            <input type="text" class="form-control" id="location" name="location" value="${event.getLocation()}" required>
                            <small class="form-text text-muted">Ex: Niamey - Palais des Congrès</small>
                        </div>
                        <div class="col-md-6">
                            <label for="eventDate" class="form-label fw-bold">Date et Heure</label>
                            <input type="datetime-local" class="form-control" id="eventDate" name="eventDate"  required>
                            <%-- <input type="datetime-local" class="form-control" id="eventDate" name="eventDate" value="${event.getEventDate()}" required> --%>
                        </div>
                    </div>

                    <h5 class="mt-4 mb-3">Types de billets</h5>
                    <div id="ticket-types-container">
                        @if(event.getTickets() != null && !event.getTickets().isEmpty())
                            @for(int i = 0; i < event.getTickets().size(); i++)
                                <div class="ticket-type-group row mb-3">
                                    <div class="col-md-5 mb-3 mb-md-0">
                                        <label for="ticket_name_${i}" class="form-label">Nom du type de billet</label>
                                        <input type="text" class="form-control" id="ticket_name_${i}" name="tickets[${i}].name" value="${event.getTickets().get(i).getName()}" placeholder="Ex: Standard, VIP" required>
                                    </div>
                                    <div class="col-md-3 mb-3 mb-md-0">
                                        <label for="ticket_price_${i}" class="form-label">Prix (XOF)</label>
                                        <input type="number" class="form-control" id="ticket_price_${i}" name="tickets[${i}].price" value="${event.getTickets().get(i).getPrice()}" min="0" step="100" required>
                                    </div>
                                    <div class="col-md-3 mb-3 mb-md-0">
                                        <label for="ticket_count_${i}" class="form-label">Nombre de tickets</label>
                                        <input type="number" class="form-control" id="ticket_count_${i}" name="tickets[${i}].count" value="${event.getTickets().get(i).getCount()}" min="1" required>
                                    </div>
                                    <div class="col-md-1 d-flex align-items-end">
                                        <button type="button" class="btn btn-danger remove-ticket-type w-100" title="Supprimer">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            @endfor
                        @else
                            <div class="ticket-type-group row mb-3">
                                <div class="col-md-5 mb-3 mb-md-0">
                                    <label for="ticket_name_0" class="form-label">Nom du type de billet</label>
                                    <input type="text" class="form-control" id="ticket_name_0" name="tickets[0].name" placeholder="Ex: Standard, VIP" required>
                                </div>
                                <div class="col-md-3 mb-3 mb-md-0">
                                    <label for="ticket_price_0" class="form-label">Prix (XOF)</label>
                                    <input type="number" class="form-control" id="ticket_price_0" name="tickets[0].price" min="0" step="100" required>
                                </div>
                                <div class="col-md-3 mb-3 mb-md-0">
                                    <label for="ticket_count_0" class="form-label">Nombre de tickets</label>
                                    <input type="number" class="form-control" id="ticket_count_0" name="tickets[0].count" min="1" required>
                                </div>
                                <div class="col-md-1 d-flex align-items-end">
                                    <button type="button" class="btn btn-danger remove-ticket-type w-100" style="display:none;" title="Supprimer">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                        @endif
                    </div>

                    <div class="mb-4">
                        <button type="button" id="add-ticket-type" class="btn btn-secondary btn-sm">
                            <i class="bi bi-plus-circle me-2"></i>
                            Ajouter un autre type de billet
                        </button>
                    </div>

                    <div class="mb-4">
                        <label for="image" class="form-label fw-bold">Image de l'événement</label>
                        @if(event.getId() == null)
                        <input class="form-control" type="file" id="image" name="image" accept="image/*"  required>
                        @else
                        <input class="form-control" type="file" id="image" name="image" accept="image/*">
                        @endif
                        <small class="form-text text-muted">Téléchargez une image pour la promotion de votre événement.</small><br>
                        <small class="form-text text-muted">Le téléchargement d'une nouvelle image remplacera la précédente.</small>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary py-2">
                            <i class="bi bi-calendar-plus me-2"></i>
                            @if(event.getId() != null)
                                Sauvegarder les modifications
                            @else
                                Créer l'événement
                            @endif
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="/js/eventForm.js"></script>
`
)