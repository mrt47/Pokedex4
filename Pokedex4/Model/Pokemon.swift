//
//  Pokemon.swift
//  Pokedex4
//
//  Created by Murat Kuran on 18/11/2017.
//  Copyright © 2017 Murat Kuran. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _defense: String!
    private var _attack: String!
    private var _nextEvoText: String!
    private var _pokemonURL: String!
    private var _evoName: String!
    private var _evoId: String!
    private var _evoLevel: String!
    
    
    var evoName: String {
        get {
            if _evoName == nil {
                _evoName = ""
            }
            return _evoName
        }
    }
    
    var evoId: String {
        get {
            if _evoId == nil {
                _evoId = ""
            }
            return _evoId
        }
    }
    
    var evoLevel: String {
        get {
            if _evoLevel == nil {
                _evoLevel = ""
            }
            return _evoLevel
        }
    }
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                _height = ""
            }
            return _height
        }
    }
    
    var weight: String {
        get {
            if _weight == nil {
                _weight = ""
            }
            return _weight
        }
    }
    
    var defense: String {
        get {
            if _defense == nil {
                _defense = ""
            }
            return _defense
        }
    }
    
    var attack: String {
        get {
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
    }
    
    var nextEvoText: String {
        get {
            if _nextEvoText == nil {
                _nextEvoText = ""
            }
            return _nextEvoText
        }
    }
    
    var name: String {
        get {
            if _name == nil {
                _name = ""
            }
            return _name
        }
    }
    
    var pokedexId: Int {
        get {
            if _pokedexId == nil {
                _pokedexId = -1
            }
            return _pokedexId
        }
    }
    
    init (name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        Alamofire.request(self._pokemonURL, method: HTTPMethod.get).responseJSON { (response) in
            let result = response.result
            
            if let dict = result.value as? Dictionary <String, AnyObject> {
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>] , stats.count > 0 {
                    if let defense = stats[3]["base_stat"] as? Int {
                        self._defense = "\(defense)"
                    }
                    if let attack = stats[4]["base_stat"] as? Int {
                        self._attack = "\(attack)"
                    }
                }
                else {
                    self._defense = ""
                    self._attack = ""
                }

                if let types = dict["types"] as? [Dictionary<String, AnyObject>] , types.count > 0 {
                    for inDict in types {
                        if let myVal = inDict["type"] as? Dictionary<String, AnyObject>{
                            if let myName = myVal["name"] as? String{
                                if self._type != nil && self._type != "" {
                                    self._type = "\(self._type!)\\\(myName.capitalized)"
                                }
                                else {
                                    self._type = myName.capitalized
                                }
                            }
                        }
                    }
                }
                else {
                    self._type = "No type"
                } // end of getting type
                
                if let species = dict["species"] as? Dictionary<String, AnyObject> {
                    if let speciesURL = species["url"] as? String {
                        Alamofire.request(speciesURL, method: HTTPMethod.get).responseJSON { (response) in
                            if let speciesDict = response.result.value as? Dictionary<String, AnyObject>{
                                if let flavor = speciesDict["flavor_text_entries"] as? [Dictionary<String, AnyObject>], flavor.count > 0 {
                                    for ss in flavor {
                                        if let language = ss["language"] as? Dictionary<String,AnyObject>{
                                            if let languageName = language["name"] as? String {
                                                if languageName == "en" {
                                                    if let flavor_text = ss["flavor_text"] as? String {
                                                        self._description = flavor_text
                                                        print(self._description)
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                else {
                                    self._description = "No description"
                                }
                                
                                if let evolution_chain = speciesDict["evolution_chain"] as? Dictionary<String, AnyObject>{
                                    if let evolution_chain_url = evolution_chain["url"] as? String {
                                        Alamofire.request(evolution_chain_url, method: HTTPMethod.get).responseJSON { (response) in
                                            if let evoDict = response.result.value as? Dictionary<String, AnyObject>{
                                                if let chain = evoDict["chain"] as? Dictionary<String,AnyObject>{
                                                    if let evolves_to = chain["evolves_to"] as? [Dictionary<String, AnyObject>] , evolves_to.count > 0 {
                                                        if let evolves_to2 = evolves_to[0]["evolves_to"] as? [Dictionary<String, AnyObject>] , evolves_to2.count > 0 {
                                                            if let evolution_details = evolves_to2[0]["evolution_details"] as? [Dictionary<String, AnyObject>] , evolution_details.count > 0 {
                                                                if let min_level = evolution_details[0]["min_level"] as? Int {
                                                                    self._evoLevel = "\(min_level)"
                                                                    print (self.evoLevel)
                                                                }
                                                            }
                                                            else {
                                                                self._evoLevel = ""
                                                            }
                                                            if let evoSpecies = evolves_to2[0]["species"] as? Dictionary<String, AnyObject> {
                                                                if let evoNm = evoSpecies["name"] as? String {
                                                                    if evoNm != "mega" {
                                                                        self._evoName = evoNm.capitalized
                                                                        print(self.evoName)
                                                                    }
                                                                }
                                                                if let evoIdUrl = evoSpecies["url"] as? String {
                                                                    let newStr = evoIdUrl.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                                                    let newestStr = newStr.replacingOccurrences(of: "/", with: "")
                                                                    self._evoId = newestStr
                                                                    print(self.evoId)
                                                                }
                                                            }
                                                        }
                                                        else {
                                                            self._evoLevel = ""
                                                            self._evoName = ""
                                                            self._evoId = ""
                                                        }
                                                    }
                                                    else {
                                                        self._evoLevel = ""
                                                        self._evoName = ""
                                                        self._evoId = ""
                                                    }
                                                }
                                            }
                                            completed()
                                        }
                                    }
                                }
                            }
                            completed()
                        }
                    }
                } //end of getting description and evolution
            }
            completed()
        }
    }
    
}

























