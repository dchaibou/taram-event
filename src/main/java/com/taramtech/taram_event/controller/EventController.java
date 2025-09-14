package com.taramtech.taram_event.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.taramtech.taram_event.dto.EventDTO;
import com.taramtech.taram_event.dto.TicketTypeDTO;
import com.taramtech.taram_event.service.EventService;
import com.taramtech.taram_event.service.ReferentielService;
import com.taramtech.taram_event.service.TicketTypeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/events")
@RequiredArgsConstructor
@Slf4j
public class EventController {

    private final EventService eventService;
    private final ReferentielService referentielService;
    private final TicketTypeService ticketTypeService;

    @GetMapping("/create")
    public String newEventForm(Model model) {
        model.addAttribute("event", new EventDTO());
        model.addAttribute("eventTypes", referentielService.findAllEventTypes());
        return "events/form";
    }

    @PostMapping("/create")
    public String createEvent(@ModelAttribute EventDTO eventDTO,
            @RequestParam("image") MultipartFile imageFile,
            RedirectAttributes redirectAttributes) {
        log.info("Création d'un évènement : {}", eventDTO);
        try {
            // First, upload the image and get the URL
            // String imageUrl = imageUploadService.upload(imageFile);
            // eventDTO.setImageUrl(imageUrl);

            // Save the event to the database via the service layer
            eventService.create(eventDTO);

            redirectAttributes.addFlashAttribute("alerts", Map.of("success", "L'événement a été créé avec succès."));
        } catch (Exception e) {
            log.error("Error creating event", e);
            redirectAttributes.addFlashAttribute("alerts",
                    Map.of("danger", "Une erreur est survenue lors de la création de l'événement."));
        }

        return "redirect:/events";
    }

    @GetMapping("/{id}/edit")
    public String editEventForm(@PathVariable Integer id, Model model) {
        Optional<EventDTO> eventOptional = eventService.findById(id);
        if (eventOptional.isEmpty()) {
            // Gérer le cas où l'événement n'est pas trouvé (redirection, 404, etc.)
            return "redirect:/events";
        }
        model.addAttribute("event", eventOptional.get());
        model.addAttribute("eventTypes", referentielService.findAllEventTypes());
        return "events/form";
    }

    // Gère la soumission du formulaire de mise à jour
    @PostMapping("/{id}/update")
    public String updateEvent(@PathVariable Integer id,
            @ModelAttribute EventDTO eventDTO,
            @RequestParam("image") MultipartFile imageFile,
            RedirectAttributes redirectAttributes) {
        try {
            // Assurez-vous que l'ID est défini dans le DTO
            eventDTO.setId(id);
            // Gérer le téléchargement de l'image si une nouvelle est fournie
            if (!imageFile.isEmpty()) {
                // Gérer le téléchargement et l'URL
            }

            eventService.update(eventDTO);
            redirectAttributes.addFlashAttribute("alerts",
                    Map.of("success", "L'événement a été mis à jour avec succès."));
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("alerts",
                    Map.of("danger", "Une erreur est survenue lors de la mise à jour de l'événement."));
        }
        return "redirect:/events";
    }

    @GetMapping("")
    public String getEvents(Model model) {

        model.addAttribute("title", "Tous les événements");
        model.addAttribute("events", eventService.findAll());
        model.addAttribute("currentPage", "eventsAll");

        return "events/list";
    }

    @GetMapping("/eventPeriod/{eventPeriod}")
    public String getEventsByPeriod(@PathVariable String eventPeriod, Model model) {

        List<EventDTO> events;
        String pageTitle;
        String currentPage;

        switch (eventPeriod.toLowerCase()) {
            case "today":
                events = eventService.findAllToday();
                pageTitle = "Évènements du jour";
                currentPage = "eventsToday";
                break;
            case "week":
                events = eventService.findAllThisWeek();
                pageTitle = "Évènements de la semaine";
                currentPage = "eventsWeek";
                break;
            case "month":
                events = eventService.findAllThisMonth();
                pageTitle = "Évènements du mois";
                currentPage = "eventsMonth";
                break;
            default:
                events = eventService.findAll();
                pageTitle = "Tous les événements";
                currentPage = "eventsAll";
                break;
        }

        model.addAttribute("title", pageTitle);
        model.addAttribute("events", events);
        model.addAttribute("currentPage", currentPage);

        return "events/list";
    }

    @GetMapping("/{id}")
    public String getEventDetails(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Optional<EventDTO> eventOptional = eventService.findById(id);

        if (eventOptional.isEmpty()) {
            redirectAttributes.addFlashAttribute("alerts", Map.of("danger", "L'événement demandé est introuvable."));
            return "redirect:/events";
        }

        EventDTO event = eventOptional.get();
        List<TicketTypeDTO> tickets = ticketTypeService.findAll(id);
        event.setTickets(tickets);

        model.addAttribute("event", event);
        model.addAttribute("currentPage", "eventDetails");
        // Les alertes sont gérées par RedirectAttributes

        return "events/details";
    }

    @PostMapping("/{id}/delete")
    public String deleteEvent(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            if (eventService.delete(id)) {
                redirectAttributes.addFlashAttribute("alerts",
                        Map.of("success", "L'événement a été supprimé avec succès."));
            } else {
                redirectAttributes.addFlashAttribute("alerts",
                        Map.of("danger", "Impossible de supprimer l'événement. Il est peut-être déjà supprimé."));
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("alerts",
                    Map.of("danger", "Une erreur est survenue lors de la suppression de l'événement."));
        }
        return "redirect:/events";
    }
}