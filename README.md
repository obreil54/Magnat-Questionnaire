# IT Audit

This project is a centralized IT audit platform built for a client to track and audit the condition of IT equipment loaned out to employees. The platform streamlines data management and reporting, making it easier for administrators and employees to track and assess the status of equipment.

## 📋 Project Overview

The IT Audit platform is a comprehensive solution used to manage and audit IT equipment across the client’s organization. It supports multiple user roles and provides a smooth, intuitive experience for both administrators and general users.

- **Administrators** can manage equipment, create reports, and oversee audit waves.
- **Employees** receive personalized questionnaires to assess the condition of loaned equipment, including laptops and other hardware.

## 💻 Technologies Used

- **Backend**: Ruby on Rails, PostgreSQL
- **Frontend**: Hotwire/Stimulus, JavaScript, HTML, CSS/SCSS
- **File Handling**: Active Record integration with the client’s file management system
- **Data Management**: Rails Admin for custom actions and reporting
- **Authentication**: Dual authentication (login-password for admins, passwordless email access for employees)

## 🛠️ Key Features

- **Multiple Authentication Methods**: 
  - Administrators log in with a traditional username/password system.
  - General users (employees) receive a passwordless login code via email for secure yet convenient access.

- **Customizable Questionnaires**: 
  - Administrators can create multiple waves of equipment questionnaires, which are tailored to specific equipment types (e.g., laptops).
  - Questionnaire types include free-text inputs, multiple-choice select options, and image uploads.

- **Image Integration**: 
  - Users can upload photos to document the condition of their equipment, and these images are seamlessly integrated into the client’s file management system using Active Record.

- **Data Import/Export**: 
  - Supports XLSX imports for adding bulk data and custom XLSX exports for generating detailed reports. These operations are managed through Rails Admin.

- **Custom Reporting**: 
  - Administrators can run custom actions via Rails Admin to generate tailored reports, improving the overall efficiency of the auditing process.

## 🌐 Live Application

The IT Audit platform is live on the client’s physical server and is currently being used by over 100 employees.

## 🏆 Project Goals

The IT Audit platform was designed to:
- Centralize the tracking and auditing of IT equipment across the organization.
- Streamline administrative workflows for handling audit data and generating reports.
- Improve user experience for employees with intuitive questionnaires and simple authentication.

---

This application is live and actively used in production by the client. Due to its proprietary nature, cloning or installing the project is not available for public use.
