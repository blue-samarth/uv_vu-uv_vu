// Ensure the DOM is fully loaded
window.addEventListener('DOMContentLoaded', () => {
    // Apply alternating row colors for better readability
    const rows = document.querySelectorAll('tbody tr');
    rows.forEach((row, index) => {
        if (index % 2 === 0) {
            row.style.backgroundColor = '#f9f9f9'; // Light gray for even rows
        } else {
            row.style.backgroundColor = '#ffffff'; // White for odd rows
        }
    });

    // Highlight rows on hover
    rows.forEach((row) => {
        row.addEventListener('mouseenter', () => {
            row.style.backgroundColor = '#e6f7ff'; // Light blue on hover
        });

        row.addEventListener('mouseleave', () => {
            const index = Array.from(rows).indexOf(row);
            row.style.backgroundColor = index % 2 === 0 ? '#f9f9f9' : '#ffffff'; // Restore original color
        });
    });

    // Style the table headers
    const headers = document.querySelectorAll('thead th');
    headers.forEach((header) => {
        header.style.backgroundColor = '#007bff'; // Bootstrap primary color
        header.style.color = '#ffffff'; // White text
        header.style.textAlign = 'center'; // Centered text
        header.style.padding = '10px';
    });

    // Center-align all table data cells
    const cells = document.querySelectorAll('tbody td');
    cells.forEach((cell) => {
        cell.style.textAlign = 'center';
        cell.style.padding = '8px';
    });
});
