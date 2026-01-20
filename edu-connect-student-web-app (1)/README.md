# 🎓 EduConnect - Student Learning Platform

A comprehensive web-based platform that connects students worldwide for collaborative learning, resource sharing, and academic success.

## 🌟 Features

### 🔐 Authentication System
- User registration with email verification
- Secure login/logout functionality
- Profile management with photo uploads
- Country and education level selection

### 📚 Resource Management
- Upload and download study materials
- Coin-based monetization system
- Subject-wise resource organization
- File storage with Supabase integration

### 💰 Premium System
- **Coin Packages**: 20 coins ($7), 50 coins ($17), 100 coins ($33)
- **Resource Pricing**: Chapter packs (1 coin), Practice packs (2 coins), Exam packs (5 coins)
- Stripe payment integration
- Real-time balance tracking

### 🏠 Study Rooms
- Create and join virtual study rooms
- Jitsi Meet video call integration
- Real-time participant management
- Subject-based room organization

### 🌍 Global Reach
- **Supported Countries**: US, UK, India, Australia, Canada, Netherlands, Singapore, Kenya, South Africa
- **Excluded**: Nigeria (as per business requirements)
- Multi-level education system support

## 🛠️ Tech Stack

- **Frontend**: HTML5, CSS3, JavaScript, Tailwind CSS
- **Backend**: Supabase (PostgreSQL, Authentication, Storage)
- **Video Calls**: Jitsi Meet External API
- **Payments**: Stripe Integration
- **File Storage**: Supabase Storage Buckets

## 📁 Project Structure

```
EduConnect/
├── index.html              # Landing page
├── signup.html             # User registration
├── login.html              # User authentication
├── dashboard.html          # Main dashboard
├── profile.html            # User profile management
├── subjects.html           # Subject browsing
├── rooms.html              # Study rooms
├── buy-coins.html          # Coin purchase page
├── payment.html            # Payment processing
├── upload-resource.html    # Resource upload
├── *.sql                   # Database schemas
└── README.md               # This file
```

## 🚀 Getting Started

### Prerequisites
- Modern web browser
- Supabase account
- Stripe account (for payments)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ikechukwu-Praise/EDUCONNECT_.git
   cd EDUCONNECT_
   ```

2. **Configure Supabase**
   - Create a new Supabase project
   - Run the SQL schema files in order:
     - `fix-study-rooms.sql`
     - `safe-profile-schema.sql`
     - `add-resource-columns.sql`
     - `fix-storage.sql`

3. **Update Configuration**
   - Replace Supabase URL and keys in all HTML files
   - Configure Stripe keys in payment system

4. **Deploy**
   - Upload files to web server or use GitHub Pages

## 💳 Payment System

### Coin Packages
| Package | Coins | Price | Best For |
|---------|-------|-------|----------|
| Starter | 20    | $7.00 | New users |
| Popular | 50    | $17.00| Regular users |
| Premium | 100   | $33.00| Power users |

### Resource Costs
- **Free Resources**: 0 coins
- **Chapter Packs**: 1 coin
- **Practice Packs**: 2 coins
- **Exam Packs**: 5 coins
- **Premium Bundles**: 10 coins

## 🎥 Video Calls

Study rooms feature integrated video calling powered by Jitsi Meet:
- HD video and audio
- Screen sharing capabilities
- Chat functionality
- Up to 20 participants per room

## 🔒 Security Features

- Row Level Security (RLS) policies
- Secure file upload validation
- Email domain restrictions
- Payment processing security

## 🌐 Live Demo

Visit: `https://ikechukwu-praise.github.io/EDUCONNECT_/`

## 📱 Responsive Design

EduConnect is fully responsive and works on:
- Desktop computers
- Tablets
- Mobile phones
- All modern browsers

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Developer

**Ikechukwu Praise**
- GitHub: [@Ikechukwu-Praise](https://github.com/Ikechukwu-Praise)
- Project: [EduConnect](https://github.com/Ikechukwu-Praise/EDUCONNECT_)

## 🆘 Support

For support and questions:
1. Check the documentation
2. Open an issue on GitHub
3. Contact the developer

---

**Built with ❤️ for students worldwide**