from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from .. import db, bcrypt
from ..models.models import User, FamilyMember

auth_bp = Blueprint("auth", __name__)


@auth_bp.post("/register")
def register():
    data = request.get_json()
    required = ["email", "password", "full_name"]
    if not all(k in data for k in required):
        return jsonify({"error": "email, password, and full_name are required"}), 400

    if User.query.filter_by(email=data["email"]).first():
        return jsonify({"error": "Email already registered"}), 409

    password_hash = bcrypt.generate_password_hash(data["password"]).decode("utf-8")
    user = User(
        email=data["email"],
        password_hash=password_hash,
        full_name=data["full_name"],
        age=data.get("age"),
        role=data.get("role", "customer"),
    )
    db.session.add(user)
    db.session.commit()

    token = create_access_token(identity=str(user.id))
    return jsonify({"user": user.to_dict(), "access_token": token}), 201


@auth_bp.post("/login")
def login():
    data = request.get_json()
    if not data or not data.get("email") or not data.get("password"):
        return jsonify({"error": "email and password are required"}), 400

    user = User.query.filter_by(email=data["email"]).first()
    if not user or not bcrypt.check_password_hash(user.password_hash, data["password"]):
        return jsonify({"error": "Invalid credentials"}), 401

    token = create_access_token(identity=str(user.id))
    return jsonify({"user": user.to_dict(), "access_token": token}), 200


@auth_bp.get("/me")
@jwt_required()
def me():
    user_id = get_jwt_identity()
    user = User.query.get_or_404(int(user_id))
    return jsonify(user.to_dict()), 200


@auth_bp.put("/me")
@jwt_required()
def update_profile():
    user_id = get_jwt_identity()
    user = User.query.get_or_404(int(user_id))
    data = request.get_json()
    user.full_name = data.get("full_name", user.full_name)
    user.age = data.get("age", user.age)
    db.session.commit()
    return jsonify(user.to_dict()), 200


@auth_bp.get("/me/family")
@jwt_required()
def list_family():
    user_id = get_jwt_identity()
    user = User.query.get_or_404(int(user_id))
    return jsonify([m.to_dict() for m in user.family_members]), 200


@auth_bp.post("/me/family")
@jwt_required()
def add_family():
    user_id = get_jwt_identity()
    data = request.get_json()
    if not data.get("name") or not data.get("age"):
        return jsonify({"error": "name and age are required"}), 400

    member = FamilyMember(
        user_id=int(user_id),
        name=data["name"],
        age=data["age"],
        relationship=data.get("relationship"),
    )
    db.session.add(member)
    db.session.commit()
    return jsonify(member.to_dict()), 201


@auth_bp.delete("/me/family/<int:member_id>")
@jwt_required()
def delete_family(member_id):
    user_id = get_jwt_identity()
    member = FamilyMember.query.filter_by(id=member_id, user_id=int(user_id)).first_or_404()
    db.session.delete(member)
    db.session.commit()
    return jsonify({"message": "Deleted"}), 200