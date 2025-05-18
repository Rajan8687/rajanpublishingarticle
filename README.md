
## Prerequisites

*   Python (>= 3.13, as specified in `pyproject.toml`)
*   Poetry (for Python dependency management)
*   Node.js and npm (for Tailwind CSS compilation)
*   Docker (optional, for running the application in a container)

## Setup and Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd <repository-name>
    ```

2.  **Environment Variables:**
    Create a `.env` file in the project root directory. This file is loaded by `python-dotenv` (used in `manage.py` and `wsgi.py`).
    Example `.env` file:
    ```env
    # Django Settings
    SECRET_KEY='your_strong_django_secret_key_here' # IMPORTANT: Change this for production
    DEBUG=True                                      # Set to False for production
    ALLOWED_HOSTS='127.0.0.1,localhost'             # Add your production host(s) here

    # Database URL (defaults to SQLite if not set, or if set to sqlite:///./db.sqlite3)
    # Example for PostgreSQL: DATABASE_URL='postgres://user:password@host:port/dbname'
    DATABASE_URL='sqlite:///./db.sqlite3'

    # Mailgun Settings (for email functionality like account verification)
    MAILGUN_API_KEY='your_mailgun_api_key'
    MAILGUN_DOMAIN='your_mailgun_domain'            # e.g., mg.yourdomain.com
    MAILGUN_EMAIL='your_mailgun_sender_email'       # e.g., noreply@mg.yourdomain.com

    # Allauth settings (example for GitHub social login, if enabled)
    # GITHUB_CLIENT_ID='your_github_client_id'
    # GITHUB_CLIENT_SECRET='your_github_client_secret'
    ```
    *Note: The `SECRET_KEY` in `settings.py` is insecure and should be replaced by an environment variable for production.*

3.  **Install Python Dependencies using Poetry:**
    ```bash
    poetry install
    ```

4.  **Install Node.js Dependencies for Tailwind CSS:**
    ```bash
    npm install
    ```

5.  **Build Tailwind CSS:**
    To compile `static/input.css` to `static/output.css`:
    The `package.json` doesn't have predefined scripts. You can run Tailwind CLI directly:
    ```bash
    npx tailwindcss -i ./static/input.css -o ./static/output.css
    ```
    For development, you can watch for changes and rebuild automatically:
    ```bash
    npx tailwindcss -i ./static/input.css -o ./static/output.css --watch
    ```
    (Consider adding these as scripts to your `package.json` for convenience).

6.  **Apply Database Migrations:**
    ```bash
    poetry run python manage.py migrate
    ```

7.  **Create a Superuser (for admin access):**
    ```bash
    poetry run python manage.py createsuperuser
    ```
    Follow the prompts to create an admin user.

8.  **Run the Development Server:**
    ```bash
    poetry run python manage.py runserver
    ```
    The application will be accessible at `http://127.0.0.1:8000/`.
    `django-browser-reload` is active, so the browser should refresh on code changes.

## Running with Docker

1.  **Build the Docker image:**
    Ensure you have Docker installed and running.
    ```bash
    docker build -t online-article-publisher .
    ```

2.  **Run the Docker container:**
    You'll need to pass environment variables to the container.
    Using an `--env-file` (recommended if you have a `.env` file):
    ```bash
    docker run -p 8000:8000 --env-file .env online-article-publisher
    ```
    Or pass environment variables individually:
    ```bash
    docker run -p 8000:8000 \
      -e SECRET_KEY='your_strong_django_secret_key_here' \
      -e DEBUG=True \
      -e DATABASE_URL='sqlite:///./db.sqlite3' \
      -e MAILGUN_API_KEY='your_mailgun_api_key' \
      -e MAILGUN_DOMAIN='your_mailgun_domain' \
      -e MAILGUN_EMAIL='your_mailgun_sender_email' \
      online-article-publisher
    ```
    *Note: The `Dockerfile` runs the server on `0.0.0.0:8000`. The `db.sqlite3` file will be created inside the container. For persistent data with Docker, consider using Docker volumes or an external database service when `DATABASE_URL` points to an external DB.*

## Usage

*   **Access the application:** Navigate to `http://127.0.0.1:8000/`.
*   **Signup/Login:**
    *   The root URL (`/`) redirects to the signup page (`/accounts/signup/`).
    *   Login at `/accounts/login/`.
    *   Other Allauth URLs are available under `/accounts/` (e.g., password reset).
*   **Article Management:**
    *   After logging in, you are redirected to the "home" page (`/articles/`) which lists your articles.
    *   Create a new article via `/articles/create/`.
    *   Update and delete your articles from the article list view.
*   **Admin Panel:** Access the Django admin panel at `http://127.0.0.1:8000/admin/` using the superuser credentials created earlier.

## Key Files Overview

*   **`manage.py`**: Django's command-line utility for administrative tasks.
*   **`djangocourse/settings.py`**: Core Django project settings, including database, installed apps, middleware, template directories, static files, and configurations for third-party apps like Allauth and Anymail.
*   **`djangocourse/urls.py`**: Main URL configuration for the project. Routes requests to the `app` application, Allauth URLs, and the admin site.
*   **`app/models.py`**: Defines the database schema:
    *   `UserProfile`: Custom user model extending `AbstractUser`, using email for login.
    *   `Article`: Model for articles, including title, content, word count (auto-calculated on save), status, and creator.
*   **`app/views.py`**: Contains class-based views for article CRUD operations (`ArticleListView`, `ArticleCreateView`, `ArticleUpdateView`, `ArticleDeleteView`). Implements `LoginRequiredMixin` and `UserPassesTestMixin` for access control.
*   **`app/admin.py`**: Customizes the Django admin interface for `UserProfile` and `Article` models, enhancing their display and manageability.
*   **`app/urls.py`**: URL routing specific to the `app` application, defining paths for article-related views.
*   **`Dockerfile`**: Defines the environment and steps to build a Docker image for the application. It uses a Python 3.13 base image, installs Poetry, installs project dependencies, and sets the entrypoint to run the Django development server.
*   **`pyproject.toml`**: Poetry's configuration file, specifying project metadata, Python version, and dependencies.
*   **`package.json`**: Lists Node.js dependencies (Tailwind CSS and its plugins) and can include scripts for managing frontend assets.
*   **`tailwind.config.js`**: Configuration file for Tailwind CSS, defining content paths, theme extensions, and plugins.
*   **`static/input.css`**: The source CSS file where Tailwind directives (`@tailwind`, `@plugin`, `@apply`) and custom CSS classes are defined.
*   **`static/output.css`**: The compiled CSS file generated by Tailwind CSS from `input.css`. This is the file linked in HTML templates.
*   **`templates/`**: (Implied by `settings.py` `TEMPLATES DIRS` and view template names) Directory containing HTML templates used by Django views.

## Environment Variables Reference

The application utilizes the following environment variables (typically set in a `.env` file):

*   `SECRET_KEY`: Django's secret key for cryptographic signing. **Critical for security.**
*   `DEBUG`: Django's debug mode (`True` for development, `False` for production).
*   `ALLOWED_HOSTS`: Comma-separated list of host/domain names that this Django site can serve.
*   `DATABASE_URL`: Database connection string (e.g., `sqlite:///./db.sqlite3`, `postgres://user:pass@host:port/dbname`).
*   `MAILGUN_API_KEY`: API key for your Mailgun account.
*   `MAILGUN_DOMAIN`: Your configured Mailgun sending domain.
*   `MAILGUN_EMAIL`: The default "from" email address for emails sent via Mailgun.
*   (Optional) Social authentication provider keys (e.g., `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`) if you enable and configure social login providers in `settings.py`.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

(Specify your license here, e.g., MIT, GPL, etc. If none, you can state "All rights reserved" or choose a license.)
