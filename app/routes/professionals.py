from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from .. import db
from ..models.models import ProfessionalProfile, User

professionals_bp = Blueprint("professionals", __name__)

@professionals_bp.get("/")
def list_professionals():
    print(">>> LIST PROFESSIONALS API called")
    specialty = request.args.get("specialty")
    available_only = request.args.get("available", "true").lower() == "true"

    query = ProfessionalProfile.query
    if specialty:
        query = query.filter_by(specialty=specialty)
    if available_only:
        query = query.filter_by(available=True)

    profiles = query.all()
    print(f">>> Returning {len(profiles)} professionals")
    return jsonify([p.to_dict() for p in profiles]), 200

@professionals_bp.get("/<int:profile_id>")
def get_professional(profile_id):
    print(f">>> GET PROFESSIONAL API called for profile_id={profile_id}")
    profile = ProfessionalProfile.query.get_or_404(profile_id)
    return jsonify(profile.to_dict()), 200

@professionals_bp.post("/profile")
@jwt_required()
def create_profile():
    print(">>> CREATE PROFESSIONAL PROFILE API called")
    user_id = get_jwt_identity()
    user = User.query.get_or_404(int(user_id))
    if user.role != "professional":
        return jsonify({"error": "Only professionals can create a profile"}), 403

    if user.professional_profile:
        return jsonify({"error": "Profile already exists. Use PUT to update."}), 409

    data = request.get_json()
    profile = ProfessionalProfile(
        user_id=int(user_id),
        specialty=data.get("specialty"),
        bio=data.get("bio"),
        certifications=data.get("certifications"),
        available=data.get("available", True),
    )
    db.session.add(profile)
    db.session.commit()
    print(f">>> Professional profile created for user_id={user_id}")
    return jsonify(profile.to_dict()), 201

@professionals_bp.put("/profile")
@jwt_required()
def update_profile():
    print(">>> UPDATE PROFESSIONAL PROFILE API called")
    user_id = get_jwt_identity()
    user = User.query.get_or_404(int(user_id))
    if not user.professional_profile:
        return jsonify({"error": "No profile found"}), 404

    data = request.get_json()
    profile = user.professional_profile
    for field in ["specialty", "bio", "certifications", "available"]:
        if field in data:
            setattr(profile, field, data[field])

    db.session.commit()
    print(f">>> Professional profile updated for user_id={user_id}")
    return jsonify(profile.to_dict()), 200