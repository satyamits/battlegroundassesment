//
//  WorkoutRouter.swift
//  BattleGroundAssement
//
//  Created by Satyam on 08/07/25.
//

import Foundation

public enum WorkoutRouter: Router {
    
    case fetchSession(sessionId: Int)
    case postOneRmExercises(param: Any)
    case fetchOneRmExercises(exerciseId: Int? = nil)
    case fetchExerciseOneRMHistroy(exerciseId: Int)
    case createSessionWorkout(params: Any)
    case createWorkout(workoutTypeId: Int, workoutSubTypeId: Int)
    case fetchWorkoutTypes
    case fetchExercises
    case updateWorkout(id: Int, params: [String: Any])
    case updateSessionsWorkout(id: Int, params: [String: Any])
    case updateOneRMExercises(param: Any)
    case deleteWorkout(id: Int)
    case postWorkoutSummary(sessionId: Int)
    
    public var method: HTTPMethod {
        switch self {
        case .createSessionWorkout, .createWorkout, .postOneRmExercises, .postWorkoutSummary:
                .post
        case .fetchWorkoutTypes, .fetchExercises, .fetchSession, .fetchOneRmExercises, .fetchExerciseOneRMHistroy:
                .get
        case .updateWorkout, .updateSessionsWorkout, .updateOneRMExercises:
                .put
        case .deleteWorkout:
                .delete
        }
    }
    
    public var path: String {
        switch self {
        case .fetchSession:
            "/api/v1/sessions/"
        case .createSessionWorkout:
            "/api/v1/sessions/start/"
        case .fetchWorkoutTypes:
            "/api/workout-types/"
        case .fetchExercises:
            "/api/exercises/"
        case .createWorkout:
            "/api/user-workouts/create/"
        case .updateSessionsWorkout(let sessionId, _):
            "/api/v1/sessions/workout/\(sessionId)/"
        case .updateWorkout(id: let id, params: _):
            "/api/user-workouts/\(id)/"
        case .deleteWorkout(let id):
            "/api/v1/sessions/session/\(id)/delete/"
        case .postOneRmExercises, .updateOneRMExercises:
            "/api/users-one-rm-info/"
        case .fetchOneRmExercises:
            "/api/users-one-rm-info/max-rm/"
        case .postWorkoutSummary:
            "/api/v1/sessions/api/insights/generate/"
        case .fetchExerciseOneRMHistroy:
            "/api/users-one-rm-info/"
        }
    }
    
    public var encodableBody: Encodable? {
            switch self {
            default: return nil
            }
        }
    
    public var params: Any? {
        switch self {
        case .updateWorkout(_, let params),
                .updateSessionsWorkout(_, let params):
            return params
        case .createSessionWorkout(let params):
            return params
        case .createWorkout(let workoutTypeId, let workoutSubTypeId):
            return [
                "workout_type_id": workoutTypeId,
                "workout_sub_type_id": workoutSubTypeId
            ]
            
        case .postOneRmExercises(let params),
                .updateOneRMExercises(let params):
            return [
                "rm_info": params
            ]
        case .postWorkoutSummary(let sessionId):
            return [
                "session_id": sessionId
            ]
        default: return nil
        }
    }
    
    public var queryParameters: [String : String]? {
        switch self {
        case .fetchSession(let sessionId):
            return ["session_id": String(sessionId)]
        case .fetchOneRmExercises(let exerciseId):
            if let exerciseId = exerciseId {
                return  ["exercise_id": String(exerciseId)]
            } else { return nil }
        case .fetchExerciseOneRMHistroy(let exerciseId):
            return ["exercise_id": String(exerciseId)]
        default : return nil
        }
    }
    
    public var keypathToMap: String? {
        switch self {
        case .createSessionWorkout, .updateSessionsWorkout, .deleteWorkout, .postOneRmExercises, .updateOneRMExercises, .postWorkoutSummary:
            return "data"
        case .fetchOneRmExercises:
                return "data.latest_records"
        default: return nil
        }
    }
}
