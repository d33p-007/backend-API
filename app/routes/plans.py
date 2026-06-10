from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from .. import db
from ..models.models import Plan, User

plans_bp = Blueprint("plans", __name__)

@plans_bp.get("/")
def list_plans():
    print(">>> LIST PLANS API called")
    plan_type = request.args.get("type")
    category = request.args.get("category")
    age = request.args.get("age", type=int)
    difficulty = request.args.get("difficulty")

    query = Plan.query
    if plan_type:
        query = query.filter_by(plan_type=plan_type)
    if category:
        query = query.filter(Plan.category.ilike(f"%{category}%"))
    if age is not None:
        query = query.filter(Plan.min_age <= age, Plan.max_age >= age)
    if difficulty:
        query = query.filter_by(difficulty=difficulty)

    plans = query.order_by(Plan.created_at.desc()).all()
    print(f">>> Returning {len(plans)} plans")
    return jsonify([p.to_dict() for p in plans]), 200

@plans_bp.get("/<int:plan_id>")
def get_plan(plan_id):
    print(f">>> GET PLAN API called for plan_id={plan_id}")
    plan = Plan.query.get_or_404(plan_id)
    return jsonify(plan.to_dict()), 200

@plans_bp.post("/")
@jwt_required()
def create_plan():
    print(">>> CREATE PLAN API called")
    user_id = get_jwt_identity()
    user = User.query.get_or_404(int(user_id))
    if user.role != "professional":
        return jsonify({"error": "Only professionals can create plans"}), 403

    data = request.get_json()
    if not data.get("title") or not data.get("plan_type"):
        return jsonify({"error": "title and plan_type are required"}), 400

    plan = Plan(
        title=data["title"],
        description=data.get("description"),
        plan_type=data["plan_type"],
        category=data.get("category"),
        min_age=data.get("min_age", 0),
        max_age=data.get("max_age", 120),
        difficulty=data.get("difficulty"),
        duration_weeks=data.get("duration_weeks"),
        created_by=int(user_id),
    )
    db.session.add(plan)
    db.session.commit()
    print(f">>> Plan created: {plan.title}")
    return jsonify(plan.to_dict()), 201

@plans_bp.put("/<int:plan_id>")
@jwt_required()
def update_plan(plan_id):
    print(f">>> UPDATE PLAN API called for plan_id={plan_id}")
    user_id = get_jwt_identity()
    plan = Plan.query.get_or_404(plan_id)
    if plan.created_by != int(user_id):
        return jsonify({"error": "Forbidden"}), 403

    data = request.get_json()
    for field in ["title", "description", "category", "min_age", "max_age", "difficulty", "duration_weeks"]:
        if field in data:
            setattr(plan, field, data[field])

    db.session.commit()
    return jsonify(plan.to_dict()), 200

@plans_bp.delete("/<int:plan_id>")
@jwt_required()
def delete_plan(plan_id):
    print(f">>> DELETE PLAN API called for plan_id={plan_id}")
    user_id = get_jwt_identity()
    plan = Plan.query.get_or_404(plan_id)
    if plan.created_by != int(user_id):
        return jsonify({"error": "Forbidden"}), 403

    db.session.delete(plan)
    db.session.commit()
    return jsonify({"message": "Deleted"}), 200