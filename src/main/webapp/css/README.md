# CSS Structure

This document outlines the CSS organization and best practices for the Book Management System.

## Directory Structure

The CSS is organized into the following directory structure:

```
css/
├── main.css                # Main CSS file that imports common styles
├── themes/
│   └── variables.css       # CSS variables for colors, typography, spacing
├── common/
│   ├── base.css            # Base element styles and resets
│   └── typography.css      # Typography styles
├── components/
│   ├── header.css          # Header component styles
│   ├── footer.css          # Footer component styles
│   ├── cards.css           # Card component styles
│   └── ... 
├── pages/
│   ├── user/
│   │   ├── home.css        # User home page styles
│   │   ├── shop.css        # Shop page styles
│   │   ├── book-detail.css # Book detail page styles
│   │   ├── cart.css        # Cart page styles
│   │   ├── checkout.css    # Checkout process styles
│   │   └── orders.css      # Order listing and detail styles
│   └── admin/
│       └── ...
└── utils/
    ├── buttons.css         # Button utility styles
    ├── forms.css           # Form utility styles
    └── animations.css      # Animation utility styles
```

## Usage Guidelines

### In JSP Files

Each JSP file should include:

1. The main CSS file
2. Page-specific CSS file

Example:

```html
<!-- Main CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
<!-- Page-specific CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user/shop.css">
```

### CSS Variables

Use the CSS variables defined in `themes/variables.css` for consistency:

```css
/* Example usage */
.my-element {
    color: var(--primary-color);
    margin: var(--spacing-m);
    border-radius: var(--border-radius-m);
}
```

### Best Practices

1. **Modularity**: Keep CSS files small and focused on specific components or pages
2. **Naming Convention**: Use BEM (Block, Element, Modifier) naming convention
   ```css
   .card { } /* Block */
   .card__title { } /* Element */
   .card--featured { } /* Modifier */
   ```
3. **Responsive Design**: Use media queries at the end of each component file
4. **Comments**: Add section comments to improve readability
5. **Avoid Hardcoding**: Use CSS variables instead of hardcoding values

## Theme Variables

The `variables.css` file contains the following variables:

### Colors
- `--primary-color`: Main brand color
- `--secondary-color`: Secondary brand color
- `--accent-color`: Accent color for highlights
- `--text-color`: Main text color
- `--light-text-color`: Secondary text color
- `--background-color`: Page background
- `--white-color`: White color
- `--border-color`: Border color
- `--success-color`: Success state color
- `--warning-color`: Warning state color
- `--error-color`: Error state color

### Typography
- `--font-family`: Base font family
- `--font-size-small`: Small text size
- `--font-size-base`: Base text size
- `--font-size-medium`: Medium text size
- `--font-size-large`: Large text size
- `--font-size-xl`: Extra large text size
- `--font-size-xxl`: Double extra large text size

### Spacing
- `--spacing-xs`: Extra small spacing
- `--spacing-s`: Small spacing
- `--spacing-m`: Medium spacing
- `--spacing-l`: Large spacing
- `--spacing-xl`: Extra large spacing
- `--spacing-xxl`: Double extra large spacing

### Border Radius
- `--border-radius-s`: Small border radius
- `--border-radius-m`: Medium border radius
- `--border-radius-l`: Large border radius
- `--border-radius-circle`: Circle border radius

### Shadows
- `--shadow-light`: Light shadow
- `--shadow-medium`: Medium shadow
- `--shadow-strong`: Strong shadow

### Transitions
- `--transition-fast`: Fast transition
- `--transition-medium`: Medium transition
- `--transition-slow`: Slow transition 