# 📊 Online Survey Management System

A comprehensive, full-featured web application for creating, managing, and analyzing online surveys. Built with **PHP** and **MySQL/MariaDB**, styled using **Bootstrap 4** and **AdminLTE**, and containerized with Docker for turnkey deployment on **[Render](https://render.com/)**.

---

## 🌟 Features Overview

- **User & Role Management:**
  - **Admin (Role 1):** Full control over users, surveys, question banks, and system reports.
  - **Staff / Employee (Role 2):** Create and manage targeted surveys.
  - **Subscriber / Respondent (Role 3):** View available surveys, submit answers, and track taken surveys.

- **Dynamic Survey Builder:**
  - Create surveys with start and end validity dates.
  - Add multiple question types:
    - 🔘 Single Choice (Radio Button options)
    - ☑️ Multiple Choice (Checkbox options)
    - 📝 Open Feedback / Comment (Textfield / Textarea)
  - Drag-and-drop or order update for questions.

- **Survey Taking & Submissions:**
  - Clean, user-friendly survey response widget.
  - Automatic validation preventing incomplete or invalid submissions.

- **Reports & Analytics:**
  - Aggregated survey responses with real-time percentage and count breakdowns.
  - Printable and exportable survey report summaries.

- **Modern Responsive UI:**
  - AdminLTE 3 dashboard theme.
  - DataTables with live search, pagination, and sorting.
  - SweetAlert2 and Toastr notifications.
  - Mobile, tablet, and desktop responsive.

---

## 🔑 Login Credentials (ID & Passwords)

Once the application is running (locally or on Render), access the login page at `/login.php`:

| Role | Email ID | Password | Access Level |
|---|---|---|---|
| 👑 **Administrator** | `admin@admin.com` | `admin123` | Full administrative control (Users, Surveys, Questions, Reports) |
| 👤 **Sample User / Respondent** | `jsmith@sample.com` | `jsmith123` | View surveys and submit responses |
| 💼 **Sample Employee / Staff** | `mcooper@sample.com` | `mcooper123` | Staff access for survey management |

> 💡 *You can also create new users and accounts with custom roles directly from the Admin Dashboard (`Users` -> `Add New`).*

---

## 🏗️ Tech Stack

- **Backend:** PHP 8.1 (Object-Oriented, MySQLi Extension)
- **Database:** MariaDB / MySQL (`survey_db.sql` schema)
- **Frontend:** HTML5, CSS3, JavaScript, jQuery, Bootstrap 4, AdminLTE 3
- **Plugins:** DataTables, Select2, Summernote WYSIWYG, SweetAlert2, Toastr, iCheck
- **Containerization:** Docker (`php:8.1-apache` + embedded MariaDB)
- **Deployment Platform:** Render (Docker Web Service / Blueprint)

---

## 🚀 Cloud Deployment on Render

This project is pre-configured for Render with:
- **Embedded Database:** Starts MariaDB automatically inside the container and auto-imports `survey_db.sql`. No external database subscription is needed!
- **Dynamic Port Binding:** Automatically listens to Render's assigned `$PORT` environment variable.
- **Fail-Safe Fallback:** If any external database credentials fail, the app automatically falls back to the embedded MariaDB to prevent downtime.

### Method 1: Using Render Blueprint (1-Click)

1. Go to [Render Dashboard](https://dashboard.render.com/).
2. Click **New +** -> **Blueprint**.
3. Connect your repository: `SurveyMangementsystem`.
4. Render automatically reads `render.yaml`.
5. Click **Apply** and wait for the build to finish.

### Method 2: Manual Web Service

1. On [Render Dashboard](https://dashboard.render.com/), click **New +** -> **Web Service**.
2. Select your repository: `SurveyMangementsystem`.
3. Set the following:
   - **Environment / Runtime:** `Docker`
   - **Branch:** `main`
   - **Root Directory:** *(leave blank / empty)*
   - **Plan:** `Free`
4. Click **Create Web Service**.

---

## ⚙️ Environment Variables (Optional)

By default, the application runs on its internal MariaDB with **zero configuration**. If you prefer to connect to an external MySQL provider (e.g. Aiven, PlanetScale, TiDB):

| Variable | Default Value | Description |
|---|---|---|
| `PORT` | `10000` | Port dynamically assigned by Render |
| `DB_HOST` | `127.0.0.1` | MySQL host (internal loopback or external IP/host) |
| `DB_PORT` | `3306` | MySQL port |
| `DB_USER` | `root` | Database username |
| `DB_PASSWORD` | *(empty)* | Database password |
| `DB_NAME` | `survey_db` | Database schema name |

---

## 💻 Local Setup & Development

### Option A: Using XAMPP / WAMP
1. Clone or copy the `survey/` folder into your web server directory (e.g. `C:\xampp\htdocs\survey`).
2. Open **phpMyAdmin** (`http://localhost/phpmyadmin`).
3. Create a new database named `survey_db`.
4. Import `survey/database/survey_db.sql` into `survey_db`.
5. Open your browser and navigate to:
   ```
   http://localhost/survey/login.php
   ```

### Option B: Using Docker Locally
```bash
# 1. Build the Docker image
docker build -t survey-management-system .

# 2. Run container on port 8080
docker run -d -p 8080:80 --name survey-app survey-management-system

# 3. Open in browser
http://localhost:8080/login.php
```

---

## 📁 Project Directory Structure

```
SurveyMangementsystem/
├── Dockerfile                   # Root Docker container definition
├── entrypoint.sh                # MariaDB auto-init & dynamic Apache port starter
├── render.yaml                  # Render 1-Click Blueprint specification
├── README.md                    # Project documentation & credentials
└── survey/                      # Application source code
    ├── assets/                  # CSS, JS, AdminLTE & Bootstrap plugins
    ├── database/
    │   └── survey_db.sql        # Database schema & sample seed data
    ├── admin_class.php          # Core PHP backend controller & CRUD logic
    ├── ajax.php                 # AJAX API request dispatcher
    ├── db_connect.php           # Database connection handler with auto-fallback
    ├── index.php                # Main dashboard & view router
    ├── login.php                # Authentication page
    ├── header.php / footer.php  # Global UI layout partials
    ├── sidebar.php / topbar.php # Navigation components
    ├── home.php                 # Dashboard view
    ├── new_survey.php           # Survey creation page
    ├── survey_list.php          # List of all surveys
    ├── manage_question.php      # Survey question editor
    ├── answer_survey.php        # Respondent survey filling interface
    ├── survey_report.php        # Analytics and responses summary
    ├── user_list.php            # User management view
    └── new_user.php             # New user registration form
```
