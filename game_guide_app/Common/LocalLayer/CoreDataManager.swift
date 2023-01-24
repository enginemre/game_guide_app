//
//  CoreDataManager.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 23.01.2023.
//

import Foundation
import CoreData




final class CoreDataManager {

    private let game: String

    init(game: String) {
        self.game = game
    }
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()
    
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.game, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }

        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\(self.game).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }

        return persistentStoreCoordinator
    }()
    
    
    func saveGame(
            _ gameDetail : GameDetail,_ note : String,
            completion : @escaping ((Result<String,ErrorTypes>) -> ()),
            isFavourite fav : Bool = false){
        if let entity = NSEntityDescription.entity(forEntityName: "GameEntity", in: managedObjectContext){
            let game = NSManagedObject(entity: entity, insertInto: managedObjectContext)
            game.setValue(Int32(gameDetail.id!), forKey: "id")
            game.setValue(gameDetail.rating, forKey: "rating")
            game.setValue(gameDetail.released, forKey: "released")
            game.setValue(gameDetail.name, forKey: "name")
            game.setValue(gameDetail.description, forKey: "descriptions")
            game.setValue(gameDetail.backgroundImage, forKey: "imageUrl")
            game.setValue(fav, forKey: "isFavourite")
            game.setValue(note, forKey: "note")
        }
        do{
            try managedObjectContext.save()
            completion(.success("Successfully"))
        }catch{
            print("Error Occured")
            completion(.failure(ErrorTypes.generalError))
        }
    }
    
    func getAllFavourites(completion : @escaping ((Result<[GameEntity]?,ErrorTypes>) -> ())) {
        let fetchRequest = GameEntity.fetchRequest()
        // Getting only favourite data
        fetchRequest.predicate = NSPredicate(format: "isFavourite == %d", true)
        var result : [GameEntity] = []
        do {
            result =  try managedObjectContext.fetch(fetchRequest)
            completion(.success(result))
        }catch{
            print("Favourites doesnt catched")
            completion(.failure(ErrorTypes.generalError))
        }
        
    }
    
    func getAllNotes(completion : @escaping ((Result<[GameEntity]?,ErrorTypes>) -> ())){
    
        let fetchRequest = GameEntity.fetchRequest()
        
        do {
            var result =  try managedObjectContext.fetch(fetchRequest)
            result = result.filter { game in
                game.note?.isEmpty == false
            }
            completion(.success(result))
        }catch{
            print("Favourites doesnt catched")
            completion(.failure(ErrorTypes.generalError))
        }
    }
    
    
    // Updating game
    func updateGame(id : Int,note : String,favourite : Bool, completion : @escaping ((Result<String,ErrorTypes>) -> ())){
        
        let fetchRequest = GameEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d",id)
        fetchRequest.fetchLimit = 1
        
        do {
            var result =  try managedObjectContext.fetch(fetchRequest)
            result.first?.note = note
            result.first?.isFavourite = favourite
            try managedObjectContext.save()
            completion(.success("Success"))
        }catch{
            print("Favourites doesnt catched")
            completion(.failure(ErrorTypes.generalError))
        }
        
    }
    
    func containData(id : Int) -> Bool {
        let fetchRequest = GameEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d",id)
        fetchRequest.fetchLimit = 1
        do {
            var result =  try managedObjectContext.fetch(fetchRequest)
            return !(result.isEmpty)
        }catch{
            print("Contains doesnt work")
            return false
        }
    }
    
    func getGameBy(id: Int, completion : @escaping ((Result<GameEntity?,ErrorTypes>) -> ())){
        let fetchRequest = GameEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d",id)
        fetchRequest.fetchLimit = 1
        do {
            var result =  try managedObjectContext.fetch(fetchRequest)
            completion(.success(result.first))
        }catch{
            print("Get game doesnt work")
            return  completion(.failure(ErrorTypes.generalError))
        }
    }
}
