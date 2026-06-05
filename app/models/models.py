from datetime import datetime
from .. import db


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(255), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(255), nullable=False)
    full_name = db.Column(db.String(255), nullable=False)
    age = db.Column(db.Integer)
    role = db.Column(db.String(50), default="customer")  # customer | professional
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    family_members = db.relationship("FamilyMember", backref="owner", lazy=True, cascade="all, delete-orphan")
    todos = db.relationship("TodoPlan", backref="user", lazy=True, cascade="all, delete-orphan")
    professional_profile = db.relationship("ProfessionalProfile", backref="user", uselist=False, cascade="all, delete-orphan")

    def to_dict(self):
        return {
            "id": self.id,
            "email": self.email,
            "full_name": self.full_name,
            "age": self.age,
            "role": self.role,
            "created_at": self.created_at.isoformat(),
        }


class FamilyMember(db.Model):
    __tablename__ = "family_members"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    name = db.Column(db.String(255), nullable=False)
    age = db.Column(db.Integer, nullable=False)
    relationship = db.Column(db.String(100))

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "age": self.age,
            "relationship": self.relationship,
        }


class Plan(db.Model):
    __tablename__ = "plans"

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text)
    plan_type = db.Column(db.String(50), nullable=False)  # diet | fitness
    category = db.Column(db.String(100))
    min_age = db.Column(db.Integer, default=0)
    max_age = db.Column(db.Integer, default=120)
    difficulty = db.Column(db.String(50))
    duration_weeks = db.Column(db.Integer)
    created_by = db.Column(db.Integer, db.ForeignKey("users.id"))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "plan_type": self.plan_type,
            "category": self.category,
            "min_age": self.min_age,
            "max_age": self.max_age,
            "difficulty": self.difficulty,
            "duration_weeks": self.duration_weeks,
            "created_at": self.created_at.isoformat(),
        }


class ProfessionalProfile(db.Model):
    __tablename__ = "professional_profiles"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), unique=True, nullable=False)
    specialty = db.Column(db.String(100))
    bio = db.Column(db.Text)
    certifications = db.Column(db.Text)
    available = db.Column(db.Boolean, default=True)

    def to_dict(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "full_name": self.user.full_name,
            "specialty": self.specialty,
            "bio": self.bio,
            "certifications": self.certifications,
            "available": self.available,
        }


class TodoPlan(db.Model):
    __tablename__ = "todo_plans"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    week_start = db.Column(db.Date, nullable=False)
    title = db.Column(db.String(255), nullable=False)
    notes = db.Column(db.Text)
    completed = db.Column(db.Boolean, default=False)
    plan_id = db.Column(db.Integer, db.ForeignKey("plans.id"), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            "id": self.id,
            "week_start": self.week_start.isoformat(),
            "title": self.title,
            "notes": self.notes,
            "completed": self.completed,
            "plan_id": self.plan_id,
            "created_at": self.created_at.isoformat(),
        }