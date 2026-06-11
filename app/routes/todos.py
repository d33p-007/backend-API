from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from .. import db
from ..models.models import TodoPlan

todos_bp = Blueprint("todos", __name__)

@todos_bp.get("/")
@jwt_required()
def list_todos():
    print(">>> LIST TODOS API called")
    user_id = get_jwt_identity()
    week_start = request.args.get("week_start")

    query = TodoPlan.query.filter_by(user_id=int(user_id))
    if week_start:
        query = query.filter_by(week_start=week_start)

    todos = query.order_by(TodoPlan.week_start.asc()).all()
    print(f">>> Returning {len(todos)} todos")
    return jsonify([t.to_dict() for t in todos]), 200

@todos_bp.post("/")
@jwt_required()
def create_todo():
    print(">>> CREATE TODO API called")
    user_id = get_jwt_identity()
    data = request.get_json()

    if not data.get("week_start") or not data.get("title"):
        return jsonify({"error": "week_start (YYYY-MM-DD) and title are required"}), 400

    todo = TodoPlan(
        user_id=int(user_id),
        week_start=data["week_start"],
        title=data["title"],
        notes=data.get("notes"),
        plan_id=data.get("plan_id"),
    )
    db.session.add(todo)
    db.session.commit()
    print(f">>> Todo created: {todo.title}")
    return jsonify(todo.to_dict()), 201

@todos_bp.put("/<int:todo_id>")
@jwt_required()
def update_todo(todo_id):
    print(f">>> UPDATE TODO API called for todo_id={todo_id}")
    user_id = get_jwt_identity()
    todo = TodoPlan.query.filter_by(id=todo_id, user_id=int(user_id)).first_or_404()

    data = request.get_json()
    for field in ["title", "notes", "completed", "week_start", "plan_id"]:
        if field in data:
            setattr(todo, field, data[field])

    db.session.commit()
    return jsonify(todo.to_dict()), 200

@todos_bp.delete("/<int:todo_id>")
@jwt_required()
def delete_todo(todo_id):
    print(f">>> DELETE TODO API called for todo_id={todo_id}")
    user_id = get_jwt_identity()
    todo = TodoPlan.query.filter_by(id=todo_id, user_id=int(user_id)).first_or_404()
    db.session.delete(todo)
    db.session.commit()
    return jsonify({"message": "Deleted"}), 200