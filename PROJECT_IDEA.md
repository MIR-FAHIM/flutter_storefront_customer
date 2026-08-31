# Storefront Customer App

## Product Idea

This app is a customer shopping experience organized around a single preferred
storefront at a time. A customer can either choose a store from the app or scan
that store's QR code. After selection, the app behaves as if the customer has
entered that store: products, categories, promotions, cart, checkout, and order
history are scoped to the selected store.

## Core Customer Flow

1. The customer opens the app and browses available stores.
2. The customer selects a store, or scans a store QR code.
3. The app resolves the store identity and sets it as the active storefront.
4. The home page reloads all store-specific content:
   - Store name, logo, banner, and storefront details
   - Product categories
   - Product lists and search results
   - Featured products and promotions
5. The customer adds products to the cart.
6. The cart, checkout, payment, and order are created for that same store.
7. The customer can switch stores later. The app must confirm or handle the
   existing cart before changing storefront context.

## Store Selection

### Store list

The customer can browse stores and open one as the active storefront. Preferred
stores should be easy to find from the Store tab.

### Store QR code

The QR code should contain a stable store identifier, preferably a public store
slug or store ID. After scanning:

- Validate the QR payload.
- Resolve the store from the backend when necessary.
- Save the active store context.
- Navigate to the store home page.
- Reload all store-scoped data.

Invalid, unknown, or inactive store QR codes should show a clear error and leave
the current storefront unchanged.

## Active Store Context

The active storefront is shared through the existing GetX service layer. It
should contain enough information to render the current store and scope API
requests:

- `store_id`
- `store_slug`
- `store_name`
- Optional logo and banner URLs

The active store should persist across app restarts for authenticated customers.
When the customer logs out, the active store context must be cleared.

Every store-dependent request must use the active store context. No global
product list should appear after a store has been selected.

## Cart and Order Rules

The cart belongs to the active storefront.

- Products from different stores must not be mixed in one cart.
- Adding a product from another store should prompt the customer to clear the
  current cart or return to the current store.
- Cart totals, delivery options, coupons, checkout, and payment must use the
  active store.
- The created order must retain the store ID or seller ID used by the backend.
- Opening an order should show the store that fulfilled it.
- Switching stores must refresh the cart from the newly selected store context.

The UI should make the active store visible on the home page and cart page so
the customer always knows where the current cart belongs.

## Main Screens

- Store list / preferred stores
- Storefront home
- Store-specific category list
- Store-specific product list and product details
- Store-specific cart
- Store-specific checkout and payment
- Store-specific order history and order details

The bottom navigation Store tab opens the customer's preferred store list. A
selected store opens the storefront home and keeps the existing GetX navigation
and module conventions.

## GetX Implementation Direction

Continue using the existing modular GetX structure:

- Store context service for the active store
- Controllers that react to active-store changes
- Repositories that append the store identifier to supported requests
- Existing API client, authentication, loading, error, and snackbar helpers
- Existing bindings and route registration patterns

When the active store changes, the relevant controllers should clear stale
store data, cancel or ignore outdated requests where supported, reload the new
store data, and refresh the cart state.

## Backend Expectations

Store-scoped endpoints should accept a store slug, store ID, or seller ID using
the backend's established convention. The customer Bearer token remains the
source of customer identity; customer IDs should not be sent in normal customer
requests unless a specific backend contract requires them.

The backend should provide or support:

- Store discovery and store details
- Store QR code identity resolution
- Store-scoped categories and products
- Store-scoped cart retrieval and mutation
- Store-scoped checkout and order creation
- Store-scoped order history

## Acceptance Criteria

- A customer can select a store from the app.
- A customer can scan a valid store QR code and enter that storefront.
- The complete product browsing experience updates to the selected store.
- Search, categories, featured products, and product details remain store-scoped.
- The cart never combines products from different stores.
- Checkout and the resulting order belong to the selected store.
- Switching stores handles an existing cart safely and refreshes store data.
- Invalid QR codes and API failures provide actionable feedback.
- Logout clears the active store and customer-specific cart state.

