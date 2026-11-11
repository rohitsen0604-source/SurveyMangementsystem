# 📊 Survey Management System

A full-featured Online Survey Management System built with PHP and MySQL/MariaDB, fully optimized and containerized for seamless 1-click deployment on **[Render](https://render.com/)**.

---

## 🚀 Key Highlights & Cloud Features

- **Turnkey Render Deployment:** Includes dynamic `$PORT` binding and embedded MariaDB engine inside the container.
- **Zero Configuration Database:** Automatically starts MariaDB and imports `survey_db.sql` on first boot. No external database subscription needed!
- **External MySQL Support:** Ready to connect to external databases (Aiven, PlanetScale, TiDB, Clever Cloud) via environment variables.
- **Render Blueprint Included (`render.yaml`):** Deploy in 1-click directly from Render Dashboard.

---

## 🔑 Default Admin Credentials

Once deployed, visit your live Render URL to log in:

- **Login URL:** `https://your-app-name.onrender.com/login.php`
- **Email:** `admin@admin.com`
- **Password:** `admin123`

---

## 🛠️ How to Deploy on Render

### Method 1: Using Render Blueprint (Recommended - 1 Click)

1. Log in to [Render Dashboard](https://dashboard.render.com/).
2. Click **New +** and select **Blueprint**.
3. Connect your GitHub repository: `SurveyMangementsystem`.
4. Render will automatically detect `render.yaml`.
5. Click **Apply**.
6. Render builds the Docker image, starts the container, imports the database, and gives you your live URL!

---

### Method 2: Manual Web Service

1. On [Render Dashboard](https://dashboard.render.com/), click **New +** -> **Web Service**.
2. Connect your GitHub repository: `rohitsen0604-source/SurveyMangementsystem`.
3. Configure the following:
   - **Name:** `survey-management-system`
   - **Region:** Any region (e.g., Oregon or Frankfurt)
   - **Branch:** `main`
   - **Runtime:** `Docker`
   - **Instance Type:** `Free`
4. Click **Create Web Service**.
5. Done! In a few minutes, your site will be live.

---

## ⚙️ Environment Variables (Optional)

By default, the container runs its own internal MariaDB with zero setup. If you wish to connect an external MySQL database:

| Variable | Default | Description |
|---|---|---|
| `PORT` | `10000` | Port dynamically assigned by Render |
| `DB_HOST` | `127.0.0.1` | Set to external DB host (e.g. `mysql.example.com`) |
| `DB_PORT` | `3306` | External database port |
| `DB_USER` | `root` | Database username |
| `DB_PASSWORD` | *(empty)* | Database password |
| `DB_NAME` | `survey_db` | Database name |

---

## 💻 Local Docker Usage (Optional)

If you have Docker installed locally:

```bash
# Build the Docker image
docker build -t survey-app .

# Run the container
docker run -d -p 8080:80 --name survey-app survey-app

# Open in browser:
# http://localhost:8080
```
