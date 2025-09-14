document.addEventListener("DOMContentLoaded", () => {
  const addTicketButton = document.getElementById("add-ticket-type");
  const ticketContainer = document.getElementById("ticket-types-container");
  let ticketIndex = 0; // Initialize the counter for ticket groups

  // Function to update input names and IDs
  const updateIndices = () => {
    const ticketGroups = ticketContainer.querySelectorAll(".ticket-type-group");
    ticketGroups.forEach((group, index) => {
      // Update input names and IDs
      group.querySelectorAll("input").forEach((input) => {
        const oldName = input.name;
        const newName = oldName.replace(/tickets\[\d+\]/g, `tickets[${index}]`);
        input.name = newName;
        input.id = input.id.replace(/\d+$/, index);
      });

      // Update label 'for' attributes
      group.querySelectorAll("label").forEach((label) => {
        const oldFor = label.getAttribute("for");
        const newFor = oldFor.replace(/\d+$/, index);
        label.setAttribute("for", newFor);
      });

      // Show/hide remove button based on number of groups
      const removeButton = group.querySelector(".remove-ticket-type");
      if (removeButton) {
        if (ticketGroups.length > 1) {
          removeButton.style.display = "block";
        } else {
          removeButton.style.display = "none";
        }
      }
    });
  };

  // Add a new ticket type group
  addTicketButton.addEventListener("click", () => {
    ticketIndex++;
    const newTicketGroup = document.createElement("div");
    newTicketGroup.className = "ticket-type-group row mb-3";
    newTicketGroup.innerHTML = `
            <div class="col-md-5 mb-3 mb-md-0">
                <label for="ticket_name_${ticketIndex}" class="form-label">Nom du type de billet</label>
                <input type="text" class="form-control" id="ticket_name_${ticketIndex}" name="tickets[${ticketIndex}].name" placeholder="Ex: VIP, Early Bird" required>
            </div>
            <div class="col-md-3 mb-3 mb-md-0">
                <label for="ticket_price_${ticketIndex}" class="form-label">Prix (XOF)</label>
                <input type="number" class="form-control" id="ticket_price_${ticketIndex}" name="tickets[${ticketIndex}].price" min="0" step="100" required>
            </div>
            <div class="col-md-3 mb-3 mb-md-0">
                <label for="ticket_count_${ticketIndex}" class="form-label">Nombre de tickets</label>
                <input type="number" class="form-control" id="ticket_count_${ticketIndex}" name="tickets[${ticketIndex}].count" min="1" required>
            </div>
            <div class="col-md-1 d-flex align-items-end">
                <button type="button" class="btn btn-danger remove-ticket-type w-100" title="Supprimer">
                    <i class="bi bi-trash"></i>
                </button>
            </div>
        `;

    ticketContainer.appendChild(newTicketGroup);
    updateIndices();
  });

  // Remove a ticket type group
  ticketContainer.addEventListener("click", (e) => {
    if (e.target.closest(".remove-ticket-type")) {
      const groupToRemove = e.target.closest(".ticket-type-group");
      if (ticketContainer.children.length > 1) {
        groupToRemove.remove();
        updateIndices();
      }
    }
  });

  // Initial check to show/hide remove button for the first element
  updateIndices();
});
