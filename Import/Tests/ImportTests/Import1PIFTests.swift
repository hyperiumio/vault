import XCTest
@testable import Import

class Import1PIFTests: XCTestCase {
    var result: [VaultItem]!
    
    override func setUp() {
        super .setUp()
        
        let data = Data(testImport.utf8)
              
        result = try! Import1PIF(from: data)
    }
    
    func testAmountOfVaultItems() throws {
        XCTAssertEqual(result.count, 18)
    }
    
    func testHuntingLicense() throws {
        let huntingLicense = result[0]
        
        XCTAssertEqual(huntingLicense.title, "Jagdschein")
        
        guard case .note(let note) = huntingLicense.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "Mein Jagdschein")
        
        guard case .genericItem(let nameKey, let nameValue) = huntingLicense.secureItems[1] else {
           return XCTFail()
        }
        XCTAssertEqual(nameKey, "name")
        XCTAssertEqual(nameValue, "Ferdinand Kühne")
        
        guard case .genericItem(let validFromKey, let validFromValue) = huntingLicense.secureItems[2] else {
           return XCTFail()
        }
        XCTAssertEqual(validFromKey, "valid_from")
        XCTAssertEqual(validFromValue, "1592481660")
        
        guard case .genericItem(let expiresKey, let expiresValue) = huntingLicense.secureItems[3] else {
           return XCTFail()
        }
        XCTAssertEqual(expiresKey, "expires")
        XCTAssertEqual(expiresValue, "1584187260")
        
        guard case .genericItem(let gameKey, let gameValue) = huntingLicense.secureItems[4] else {
           return XCTFail()
        }
        XCTAssertEqual(gameKey, "game")
        XCTAssertEqual(gameValue, "Hirsch, Iltis, Grottenolm")
        
        guard case .genericItem(let quotaKey, let quotaValue) = huntingLicense.secureItems[5] else {
           return XCTFail()
        }
        XCTAssertEqual(quotaKey, "quota")
        XCTAssertEqual(quotaValue, "1")
        
        guard case .genericItem(let stateKey, let stateValue) = huntingLicense.secureItems[6] else {
           return XCTFail()
        }
        XCTAssertEqual(stateKey, "state")
        XCTAssertEqual(stateValue, "Bayern")
        
        guard case .genericItem(let countryKey, let countryValue) = huntingLicense.secureItems[7] else {
           return XCTFail()
        }
        XCTAssertEqual(countryKey, "country")
        XCTAssertEqual(countryValue, "Germany")
        
        guard case .genericItem(let unsetKey, let unsetValue) = huntingLicense.secureItems[8] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey, "122AA14967774EE1BE8B370308B1827A")
        XCTAssertEqual(unsetValue, "Mainstreet 99")
        
        guard case .genericItem(let unsetKey2, let unsetValue2) = huntingLicense.secureItems[9] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey2, "BC9DF508BA004F7EBEDE5D624E36473F")
        XCTAssertEqual(unsetValue2, "73829 Grottenolmhausen")
        
        guard case .genericItem(let unsetKey3, let unsetValue3) = huntingLicense.secureItems[10] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey3, "B9E78EAAF5AE4F4E822087D1533BFD1A")
        XCTAssertEqual(unsetValue3, "asfascascasfasf")
        
        guard case .genericItem(let unsetKey4, let unsetValue4) = huntingLicense.secureItems[11] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey4, "E276D5380E304B648CB451EB66761C71")
        XCTAssertEqual(unsetValue4, "afaasfasrraxdcvadf")
        
        guard case .genericItem(let unsetKey5, let unsetValue5) = huntingLicense.secureItems[12] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey5, "9B265842297645889A323D20AEEB38EA")
        XCTAssertEqual(unsetValue5, "ersdvsaesd")
        
        guard case .genericItem(let unsetKey6, let unsetValue6) = huntingLicense.secureItems[13] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey6, "EAAB875F0A5044529C3B488D4DA179A9")
        XCTAssertEqual(unsetValue6, "bxdfwqaresg")
    }
    
    func testPassword() throws {
        let password = result[1]
        
        XCTAssertEqual(password.title, "Passwort")
        
        guard case .password(let extractedPassword) = password.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(extractedPassword, "iamsecretpassword")
        
        guard case .genericItem(let unsetKey, let unsetValue) = password.secureItems[1] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey, "D19B5C84C1054EB7BCD648C56672EF1F")
        XCTAssertEqual(unsetValue, "asfasfasfasfa")
        
        guard case .genericItem(let unsetKey2, let unsetValue2) = password.secureItems[2] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey2, "E174AFCAE0C0411DB1EF8504397F0414")
        XCTAssertEqual(unsetValue2, "fghdgfd")
        
        guard case .genericItem(let unsetKey3, let unsetValue3) = password.secureItems[3] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey3, "B2080ADEB50A4AE7AD8334D0AD476C9F")
        XCTAssertEqual(unsetValue3, "xbcdvbdfdfg")
        
        guard case .genericItem(let unsetKey4, let unsetValue4) = password.secureItems[4] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey4, "55A17E30FC9C451BB457AF22A31C702C")
        XCTAssertEqual(unsetValue4, "dfgdgdfg")
        
        guard case .genericItem(let unsetKey5, let unsetValue5) = password.secureItems[5] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey5, "9F19915367E442318518E7EAA8050B7F")
        XCTAssertEqual(unsetValue5, "dfgdfgdfgdf")
        
        guard case .note(let note) = password.secureItems[6] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "i am your password")
    }
    
    func testPass() throws {
        let pass = result[2]
        
        XCTAssertEqual(pass.title, "Passierschein")
        
        guard case .note(let note) = pass.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "Dies ist der Passierschein")
        
        guard case .genericItem(let fullnameKey, let fullnameValue) = pass.secureItems[1] else {
           return XCTFail()
        }
        XCTAssertEqual(fullnameKey, "fullname")
        XCTAssertEqual(fullnameValue, "Ferdinand")
        
        guard case .genericItem(let addressKey, let addressValue) = pass.secureItems[2] else {
           return XCTFail()
        }
        XCTAssertEqual(addressKey, "address")
        XCTAssertEqual(addressValue, "")
        
        guard case .genericItem(let birthdateKey, let birthdateValue) = pass.secureItems[3] else {
           return XCTFail()
        }
        XCTAssertEqual(birthdateKey, "birthdate")
        XCTAssertEqual(birthdateValue, "1592913660")
        
        guard case .genericItem(let genderKey, let genderValue) = pass.secureItems[4] else {
           return XCTFail()
        }
        XCTAssertEqual(genderKey, "sex")
        XCTAssertEqual(genderValue, nil)
        
        guard case .genericItem(let heightKey, let heightValue) = pass.secureItems[5] else {
           return XCTFail()
        }
        XCTAssertEqual(heightKey, "height")
        XCTAssertEqual(heightValue, "1.97")
        
        guard case .genericItem(let numberKey, let numberValue) = pass.secureItems[6] else {
           return XCTFail()
        }
        XCTAssertEqual(numberKey, "number")
        XCTAssertEqual(numberValue, "010101281231")
        
        guard case .genericItem(let classKey, let classValue) = pass.secureItems[7] else {
           return XCTFail()
        }
        XCTAssertEqual(classKey, "class")
        XCTAssertEqual(classValue, "B")
        
        guard case .genericItem(let conditionsKey, let conditionsValue) = pass.secureItems[8] else {
           return XCTFail()
        }
        XCTAssertEqual(conditionsKey, "conditions")
        XCTAssertEqual(conditionsValue, "Keine Dreisine")
        
        guard case .genericItem(let stateKey, let stateValue) = pass.secureItems[9] else {
           return XCTFail()
        }
        XCTAssertEqual(stateKey, "state")
        XCTAssertEqual(stateValue, "Bayern")
        
        guard case .genericItem(let countryKey, let countryValue) = pass.secureItems[10] else {
           return XCTFail()
        }
        XCTAssertEqual(countryKey, "country")
        XCTAssertEqual(countryValue, "")
        
        guard case .genericItem(let expiryKey, let expiryValue) = pass.secureItems[11] else {
           return XCTFail()
        }
        XCTAssertEqual(expiryKey, "expiry_date")
        XCTAssertEqual(expiryValue, "202002")
        
        guard case .genericItem(let unsetKey, let unsetValue) = pass.secureItems[12] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey, "017662C81DF043BC9265EF5FF510DB54")
        XCTAssertEqual(unsetValue, "12012340123")
        
        guard case .genericItem(let unsetKey2, let unsetValue2) = pass.secureItems[13] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey2, "8D07140CD8F542E1B754D449BC9ADB0C")
        XCTAssertEqual(unsetValue2, "kajsfkasjfkasf")
        
        guard case .genericItem(let unsetKey3, let unsetValue3) = pass.secureItems[14] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey3, "5EFA80AC728A460F8E3CCD474A18141C")
        XCTAssertEqual(unsetValue3, "kasdjfgkshdkgsd")
    }
    
    func testSQL() throws {
        let sql = result[3]
        
        XCTAssertEqual(sql.title, "SQL")
        
        guard case .note(let note) = sql.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "very important database")
        
        guard case .genericItem(let databaseTypeKey, let databaseTypeValue) = sql.secureItems[1] else {
           return XCTFail()
        }
        XCTAssertEqual(databaseTypeKey, "database_type")
        XCTAssertEqual(databaseTypeValue, "mysql")

                guard case .genericItem(let hostnameKey, let hostnameValue) = sql.secureItems[2] else {
           return XCTFail()
        }
        XCTAssertEqual(hostnameKey, "hostname")
        XCTAssertEqual(hostnameValue, "super_server")

                        guard case .genericItem(let portKey, let portValue) = sql.secureItems[3] else {
           return XCTFail()
        }
        XCTAssertEqual(portKey, "port")
        XCTAssertEqual(portValue, "12")

                        guard case .genericItem(let databaseKey, let databaseValue) = sql.secureItems[4] else {
           return XCTFail()
        }
        XCTAssertEqual(databaseKey, "database")
        XCTAssertEqual(databaseValue, "SQL 1.2")

                        guard case .genericItem(let usernameKey, let usernameValue) = sql.secureItems[5] else {
           return XCTFail()
        }
        XCTAssertEqual(usernameKey, "username")
        XCTAssertEqual(usernameValue, "Dr Database")

                        guard case .genericItem(let passwordKey, let passwordValue) = sql.secureItems[6] else {
           return XCTFail()
        }
        XCTAssertEqual(passwordKey, "password")
        XCTAssertEqual(passwordValue, "database_password")

                        guard case .genericItem(let sidKey, let sidValue) = sql.secureItems[7] else {
           return XCTFail()
        }
        XCTAssertEqual(sidKey, "sid")
        XCTAssertEqual(sidValue, "9181821301")

                        guard case .genericItem(let aliasKey, let aliasValue) = sql.secureItems[8] else {
           return XCTFail()
        }
        XCTAssertEqual(aliasKey, "alias")
        XCTAssertEqual(aliasValue, "12124121411")

                        guard case .genericItem(let optionsKey, let optionsValue) = sql.secureItems[9] else {
           return XCTFail()
        }
        XCTAssertEqual(optionsKey, "options")
        XCTAssertEqual(optionsValue, "connector1")

                                guard case .genericItem(let unsetKey, let unsetValue) = sql.secureItems[10] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey, "90F2F12507504DAEB2358309280EB95A")
        XCTAssertEqual(unsetValue, "connector2")

                                guard case .genericItem(let unsetKey2, let unsetValue2) = sql.secureItems[11] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey2, "9A1753DF7E0649FDAC0F26B589AF2373")
        XCTAssertEqual(unsetValue2, "jakfsjasakjasf")
    }
    
    func testBankAccount() throws {
        let bankAccount = result[4]
        
        XCTAssertEqual(bankAccount.title, "Bankkonto")
        
        guard case .note(let note) = bankAccount.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "Mein liebstes Bankkonto")
        
                guard case .genericItem(let bankNameKey, let bankNameValue) = bankAccount.secureItems[1] else {
                  return XCTFail()
               }
               XCTAssertEqual(bankNameKey, "bankName")
               XCTAssertEqual(bankNameValue, "Volksbank")

                       guard case .genericItem(let ownerKey, let ownerValue) = bankAccount.secureItems[2] else {
                  return XCTFail()
               }
               XCTAssertEqual(ownerKey, "owner")
               XCTAssertEqual(ownerValue, "Max Mustermann")

                               guard case .genericItem(let accountTypeKey, let accountTypeValue) = bankAccount.secureItems[3] else {
                  return XCTFail()
               }
               XCTAssertEqual(accountTypeKey, "accountType")
               XCTAssertEqual(accountTypeValue, "savings")

                               guard case .genericItem(let routingNoKey, let routingNoValue) = bankAccount.secureItems[4] else {
                  return XCTFail()
               }
               XCTAssertEqual(routingNoKey, "routingNo")
               XCTAssertEqual(routingNoValue, "678199200")

                               guard case .genericItem(let accountNoKey, let accountNoValue) = bankAccount.secureItems[5] else {
                  return XCTFail()
               }
               XCTAssertEqual(accountNoKey, "accountNo")
               XCTAssertEqual(accountNoValue, "22671794")

                               guard case .genericItem(let swiftKey, let swiftValue) = bankAccount.secureItems[6] else {
                  return XCTFail()
               }
               XCTAssertEqual(swiftKey, "swift")
               XCTAssertEqual(swiftValue, "00 31 71 582 2822")

                               guard case .genericItem(let ibanKey, let ibanValue) = bankAccount.secureItems[7] else {
                  return XCTFail()
               }
               XCTAssertEqual(ibanKey, "iban")
               XCTAssertEqual(ibanValue, "NL15ABNA5172064443")

                               guard case .genericItem(let telephonePinKey, let telephonePinValue) = bankAccount.secureItems[8] else {
                  return XCTFail()
               }
               XCTAssertEqual(telephonePinKey, "telephonePin")
               XCTAssertEqual(telephonePinValue, "1238")

                               guard case .genericItem(let unsetKey, let unsetValue) = bankAccount.secureItems[9] else {
                  return XCTFail()
               }
               XCTAssertEqual(unsetKey, "4EA7F91E251B4F2FA3624F7938C78482")
               XCTAssertEqual(unsetValue, "jsadfjis")

                                       guard case .genericItem(let branchPhoneKey, let branchPhoneValue) = bankAccount.secureItems[10] else {
                  return XCTFail()
               }
               XCTAssertEqual(branchPhoneKey, "branchPhone")
               XCTAssertEqual(branchPhoneValue, "081234911")

                                       guard case .genericItem(let branchAddressKey, let branchAddressValue) = bankAccount.secureItems[11] else {
                  return XCTFail()
               }
               XCTAssertEqual(branchAddressKey, "branchAddress")
               XCTAssertEqual(branchAddressValue, "1 Mainstreet")
    }
    
    func testMembership() throws {
        let membership = result[5]
        
        XCTAssertEqual(membership.title, "Mitgliedschaft")
        
        guard case .genericItem(let orgNameKey, let orgNameValue) = membership.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(orgNameKey, "org_name")
        XCTAssertEqual(orgNameValue, "PETA")

        guard case .genericItem(let websiteKey, let websiteValue) = membership.secureItems[1] else {
           return XCTFail()
        }
        XCTAssertEqual(websiteKey, "website")
        XCTAssertEqual(websiteValue, "peta.com")

                guard case .genericItem(let phoneKey, let phoneValue) = membership.secureItems[2] else {
           return XCTFail()
        }
        XCTAssertEqual(phoneKey, "phone")
        XCTAssertEqual(phoneValue, "0123121121")

                        guard case .genericItem(let memberNameKey, let memberNameValue) = membership.secureItems[3] else {
           return XCTFail()
        }
        XCTAssertEqual(memberNameKey, "member_name")
        XCTAssertEqual(memberNameValue, "Ferdinand")

                        guard case .genericItem(let memberSinceKey, let memberSinceValue) = membership.secureItems[4] else {
           return XCTFail()
        }
        XCTAssertEqual(memberSinceKey, "member_since")
        XCTAssertEqual(memberSinceValue, "202005")

                        guard case .genericItem(let expiryDateKey, let expiryDateValue) = membership.secureItems[5] else {
           return XCTFail()
        }
        XCTAssertEqual(expiryDateKey, "expiry_date")
        XCTAssertEqual(expiryDateValue, "200112")

                        guard case .genericItem(let membershipNoKey, let membershipNoValue) = membership.secureItems[6] else {
           return XCTFail()
        }
        XCTAssertEqual(membershipNoKey, "membership_no")
        XCTAssertEqual(membershipNoValue, "122")

                        guard case .genericItem(let pinKey, let pinValue) = membership.secureItems[7] else {
           return XCTFail()
        }
        XCTAssertEqual(pinKey, "pin")
        XCTAssertEqual(pinValue, "password")

                        guard case .genericItem(let unsetKey, let unsetValue) = membership.secureItems[8] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey, "2064D0B78411437EAA90AC9E49016836")
        XCTAssertEqual(unsetValue, "adsgadsgadsg")

                        guard case .genericItem(let unsetKey2, let unsetValue2) = membership.secureItems[9] else {
           return XCTFail()
        }
        XCTAssertEqual(unsetKey2, "927CB1C6966842DD8FC9C76FD36F5F42")
        XCTAssertEqual(unsetValue2, "sdgsdgsdg")
    }
    
    func testEmailAccount() throws {
        let emailAccount = result[6]
        
        XCTAssertEqual(emailAccount.title, "E-Mail-Konto")
        
        guard case .note(let note) = emailAccount.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "This is an email account")
        

        
        guard case .genericItem(let pop_typeKey, let pop_typeValue) = emailAccount.secureItems[1] else {
            return XCTFail()
        }

        XCTAssertEqual(pop_typeKey, "pop_type")
        XCTAssertEqual(pop_typeValue, "imap")

        guard case .genericItem(let pop_usernameKey, let pop_usernameValue) = emailAccount.secureItems[2] else {
            return XCTFail()
        }

        XCTAssertEqual(pop_usernameKey, "pop_username")
        XCTAssertEqual(pop_usernameValue, "Dr Email")

        guard case .genericItem(let pop_serverKey, let pop_serverValue) = emailAccount.secureItems[3] else {
            return XCTFail()
        }

        XCTAssertEqual(pop_serverKey, "pop_server")
        XCTAssertEqual(pop_serverValue, "xafsoajsf")

        guard case .genericItem(let pop_portKey, let pop_portValue) = emailAccount.secureItems[4] else {
            return XCTFail()
        }

        XCTAssertEqual(pop_portKey, "pop_port")
        XCTAssertEqual(pop_portValue, "222")

        guard case .genericItem(let pop_passwordKey, let pop_passwordValue) = emailAccount.secureItems[5] else {
            return XCTFail()
        }

        XCTAssertEqual(pop_passwordKey, "pop_password")
        XCTAssertEqual(pop_passwordValue, "emailapssword")

        guard case .genericItem(let pop_securityKey, let pop_securityValue) = emailAccount.secureItems[6] else {
            return XCTFail()
        }

        XCTAssertEqual(pop_securityKey, "pop_security")
        XCTAssertEqual(pop_securityValue, "SSL")

        guard case .genericItem(let pop_authenticationKey, let pop_authenticationValue) = emailAccount.secureItems[7] else {
            return XCTFail()
        }

        XCTAssertEqual(pop_authenticationKey, "pop_authentication")
        XCTAssertEqual(pop_authenticationValue, "kerberized_pop")
        guard case .genericItem(let unsetKey4, let unsetValue4) = emailAccount.secureItems[8]
        else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey4, "596414580AE249F1A7D407AB83376146")
        XCTAssertEqual(unsetValue4, "ajsfasfasofa")

        guard case .genericItem(let smtp_serverKey, let smtp_serverValue) = emailAccount.secureItems[9] else {
            return XCTFail()
        }

        XCTAssertEqual(smtp_serverKey, "smtp_server")
        XCTAssertEqual(smtp_serverValue, "iamsmtpserver")

        guard case .genericItem(let smtp_portKey, let smtp_portValue) = emailAccount.secureItems[10] else {
            return XCTFail()
        }

        XCTAssertEqual(smtp_portKey, "smtp_port")
        XCTAssertEqual(smtp_portValue, "1231")

        guard case .genericItem(let smtp_usernameKey, let smtp_usernameValue) = emailAccount.secureItems[11] else {
            return XCTFail()
        }

        XCTAssertEqual(smtp_usernameKey, "smtp_username")
        XCTAssertEqual(smtp_usernameValue, "Prof Email")

        guard case .genericItem(let smtp_passwordKey, let smtp_passwordValue) = emailAccount.secureItems[12] else {
            return XCTFail()
        }

        XCTAssertEqual(smtp_passwordKey, "smtp_password")
        XCTAssertEqual(smtp_passwordValue, "mailingpassword")

        guard case .genericItem(let smtp_securityKey, let smtp_securityValue) = emailAccount.secureItems[13] else {
            return XCTFail()
        }

        XCTAssertEqual(smtp_securityKey, "smtp_security")
        XCTAssertEqual(smtp_securityValue, "SSL")

        guard case .genericItem(let smtp_authenticationKey, let smtp_authenticationValue) = emailAccount.secureItems[14] else {
            return XCTFail()
        }

        XCTAssertEqual(smtp_authenticationKey, "smtp_authentication")
        XCTAssertEqual(smtp_authenticationValue, "password")
        guard case .genericItem(let unsetKey, let unsetValue) = emailAccount.secureItems[15]
        else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey, "1725CF4ED5944B658B690896D2A02C0B")
        XCTAssertEqual(unsetValue, "iashifhasf")

        guard case .genericItem(let providerKey, let providerValue) = emailAccount.secureItems[16] else {
            return XCTFail()
        }

        XCTAssertEqual(providerKey, "provider")
        XCTAssertEqual(providerValue, "Strato")

        guard case .genericItem(let provider_websiteKey, let provider_websiteValue) = emailAccount.secureItems[17] else {
            return XCTFail()
        }

        XCTAssertEqual(provider_websiteKey, "provider_website")
        XCTAssertEqual(provider_websiteValue, "strato.de")

        guard case .genericItem(let phone_localKey, let phone_localValue) = emailAccount.secureItems[18] else {
            return XCTFail()
        }

        XCTAssertEqual(phone_localKey, "phone_local")
        XCTAssertEqual(phone_localValue, "0123818181")

        guard case .genericItem(let phone_tollfreeKey, let phone_tollfreeValue) = emailAccount.secureItems[19] else {
            return XCTFail()
        }

        XCTAssertEqual(phone_tollfreeKey, "phone_tollfree")
        XCTAssertEqual(phone_tollfreeValue, "012319111")
        
        guard case .genericItem(let unsetKey2, let unsetValue2) = emailAccount.secureItems[20]
        else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey2, "E680C2D98D2A41639ACA892EEED1417F")
        XCTAssertEqual(unsetValue2, "ashfiasfhasf")
        guard case .genericItem(let unsetKey3, let unsetValue3) = emailAccount.secureItems[21]
        else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey3, "0232D58F833C40049D6EB63059846BA2")
        XCTAssertEqual(unsetValue3, "sjasofjasofjaooadfsdf")
    }
    
    func testPassport() throws {
        let passport = result[7]
    
        XCTAssertEqual(passport.title, "Reisepass")
        
        guard case .genericItem(let typeKey, let typeValue) = passport.secureItems[0] else {
            return XCTFail()
        }

        XCTAssertEqual(typeKey, "type")
        XCTAssertEqual(typeValue, "Reisepass")

        guard case .genericItem(let issuingCountryKey, let issuingCountryValue) = passport.secureItems[1] else {
            return XCTFail()
        }


        XCTAssertEqual(issuingCountryKey, "issuing_country")
        XCTAssertEqual(issuingCountryValue, "Deutschland")

        guard case .genericItem(let numberKey, let numberValue) = passport.secureItems[2] else {
            return XCTFail()
        }


        XCTAssertEqual(numberKey, "number")
        XCTAssertEqual(numberValue, "0101293111")

        guard case .genericItem(let fullnameKey, let fullnameValue) = passport.secureItems[3] else {
            return XCTFail()
        }


        XCTAssertEqual(fullnameKey, "fullname")
        XCTAssertEqual(fullnameValue, "Ferdinand")

        guard case .genericItem(let sexKey, let sexValue) = passport.secureItems[4] else {
            return XCTFail()
        }


        XCTAssertEqual(sexKey, "sex")
        XCTAssertEqual(sexValue, "female")

        guard case .genericItem(let nationalityKey, let nationalityValue) = passport.secureItems[5] else {
            return XCTFail()
        }


        XCTAssertEqual(nationalityKey, "nationality")
        XCTAssertEqual(nationalityValue, "Deutschland")

        guard case .genericItem(let issuingAuthorityKey, let issuingAuthorityValue) = passport.secureItems[6] else {
            return XCTFail()
        }


        XCTAssertEqual(issuingAuthorityKey, "issuing_authority")
        XCTAssertEqual(issuingAuthorityValue, "Deutsches Reisepassamt")

        guard case .genericItem(let birthdateKey, let birthdateValue) = passport.secureItems[7] else {
            return XCTFail()
        }


        XCTAssertEqual(birthdateKey, "birthdate")
        XCTAssertEqual(birthdateValue, "1587211260")

        guard case .genericItem(let birthplaceKey, let birthplaceValue) = passport.secureItems[8] else {
            return XCTFail()
        }


        XCTAssertEqual(birthplaceKey, "birthplace")
        XCTAssertEqual(birthplaceValue, "234234234")

        guard case .genericItem(let issueDateKey, let issueDateValue) = passport.secureItems[9] else {
            return XCTFail()
        }


        XCTAssertEqual(issueDateKey, "issue_date")
        XCTAssertEqual(issueDateValue, "1589025660")

        guard case .genericItem(let expiryDateKey, let expiryDateValue) = passport.secureItems[10] else {
            return XCTFail()
        }


        XCTAssertEqual(expiryDateKey, "expiry_date")
        XCTAssertEqual(expiryDateValue, "1588939260")

        guard case .genericItem(let unsetKey, let unsetValue) = passport.secureItems[11] else {
            return XCTFail()
        }


        XCTAssertEqual(unsetKey, "4F8F1B9CE2B74380ACEF9E8DE2ABCF04")
        XCTAssertEqual(unsetValue, "afasfasfasfasfasf")

    }
    
    func testServer() throws {
        let server = result[8]
        
        XCTAssertEqual(server.title, "Server")
        
        guard case .note(let note) = server.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "I am your server")
        
        guard case .genericItem(let urlKey, let urlValue) = server.secureItems[1] else {
            return XCTFail()
        }

        XCTAssertEqual(urlKey, "url")
        XCTAssertEqual(urlValue, "server.com")

        guard case .genericItem(let usernameKey, let usernameValue) = server.secureItems[2] else {
            return XCTFail()
        }

        XCTAssertEqual(usernameKey, "username")
        XCTAssertEqual(usernameValue, "server1")

        guard case .genericItem(let passwordKey, let passwordValue) = server.secureItems[3] else {
            return XCTFail()
        }

        XCTAssertEqual(passwordKey, "password")
        XCTAssertEqual(passwordValue, "iampassword")

        guard case .genericItem(let unsetKey, let unsetValue) = server.secureItems[4] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey, "99B56366BF3B4877897A5AC7A8B1131B")
        XCTAssertEqual(unsetValue, "adfsdfsdfsdf")

        guard case .genericItem(let admin_console_urlKey, let admin_console_urlValue) = server.secureItems[5] else {
            return XCTFail()
        }

        XCTAssertEqual(admin_console_urlKey, "admin_console_url")
        XCTAssertEqual(admin_console_urlValue, "server.com/admin")

        guard case .genericItem(let admin_console_usernameKey, let admin_console_usernameValue) = server.secureItems[6] else {
            return XCTFail()
        }

        XCTAssertEqual(admin_console_usernameKey, "admin_console_username")
        XCTAssertEqual(admin_console_usernameValue, "user1")

        guard case .genericItem(let admin_console_passwordKey, let admin_console_passwordValue) = server.secureItems[7] else {
            return XCTFail()
        }

        XCTAssertEqual(admin_console_passwordKey, "admin_console_password")
        XCTAssertEqual(admin_console_passwordValue, "iampassword")

        guard case .genericItem(let unsetKey2, let unsetValue2) = server.secureItems[8] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey2, "C4EA932A85D14747BB316A814B3F116F")
        XCTAssertEqual(unsetValue2, "iadshjfiahdsfisd")

        guard case .genericItem(let nameKey, let nameValue) = server.secureItems[9] else {
            return XCTFail()
        }

        XCTAssertEqual(nameKey, "name")
        XCTAssertEqual(nameValue, "Ur Server")

        guard case .genericItem(let websiteKey, let websiteValue) = server.secureItems[10] else {
            return XCTFail()
        }

        XCTAssertEqual(websiteKey, "website")
        XCTAssertEqual(websiteValue, "amazingserver.com")

        guard case .genericItem(let supportContactUrlKey, let supportContactUrlValue) = server.secureItems[11] else {
            return XCTFail()
        }

        XCTAssertEqual(supportContactUrlKey, "support_contact_url")
        XCTAssertEqual(supportContactUrlValue, "server.com/support")

        guard case .genericItem(let supportContactPhoneKey, let supportContactPhoneValue) = server.secureItems[12] else {
            return XCTFail()
        }

        XCTAssertEqual(supportContactPhoneKey, "support_contact_phone")
        XCTAssertEqual(supportContactPhoneValue, "910239123")

        guard case .genericItem(let unsetKey3, let unsetValue3) = server.secureItems[13] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey3, "79633FD4B0E4471890C431E39CF0136A")
        XCTAssertEqual(unsetValue3, "ojsdfikhsdfihsdf")

    }
    
    func testSocialSecurityNumber() throws {
        let socialSecurityNumber = result[9]
        
        XCTAssertEqual(socialSecurityNumber.title, "Sozialversicherungsnummer")
        
        guard case .note(let note) = socialSecurityNumber.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "dies ist meine sozialversicherungsnummer")
        
        guard case .genericItem(let nameKey, let nameValue) = socialSecurityNumber.secureItems[1] else {
            return XCTFail()
        }

        XCTAssertEqual(nameKey, "name")
        XCTAssertEqual(nameValue, "Ferdinand")

        guard case .genericItem(let numberKey, let numberValue) = socialSecurityNumber.secureItems[2] else {
            return XCTFail()
        }

        XCTAssertEqual(numberKey, "number")
        XCTAssertEqual(numberValue, "92378923y429382038423")

        guard case .genericItem(let unsetKey, let unsetValue) = socialSecurityNumber.secureItems[3] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey, "226A17AB8C0941B6AC490B529E401AA1")
        XCTAssertEqual(unsetValue, "hsdhfjsdfhjsdf")

        guard case .genericItem(let unsetKey2, let unsetValue2) = socialSecurityNumber.secureItems[4] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey2, "836B9469D2CC4714A38EBBFD42E1DAAA")
        XCTAssertEqual(unsetValue2, "hsdjfsdhf")

    }
    
    func testSoftwareLicense() throws {
        let softwareLicense = result[10]
        
        XCTAssertEqual(softwareLicense.title, "Softwarelizenz")
        
        guard case .note(let note) = softwareLicense.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "dies ist eine firmenlizenz")
        
        guard case .genericItem(let productVersionKey, let productVersionValue) = softwareLicense.secureItems[1] else {
            return XCTFail()
        }

        XCTAssertEqual(productVersionKey, "product_version")
        XCTAssertEqual(productVersionValue, "1.2")

        guard case .genericItem(let regCodeKey, let regCodeValue) = softwareLicense.secureItems[2] else {
            return XCTFail()
        }

        XCTAssertEqual(regCodeKey, "reg_code")
        XCTAssertEqual(regCodeValue, "9872394-2930423-8920342034\t")

        guard case .genericItem(let unsetKey, let unsetValue) = softwareLicense.secureItems[3] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey, "EDD074F3C0974A9B8556EE6BF8B4BF16")
        XCTAssertEqual(unsetValue, "4234234")

        guard case .genericItem(let regNameKey, let regNameValue) = softwareLicense.secureItems[4] else {
            return XCTFail()
        }

        XCTAssertEqual(regNameKey, "reg_name")
        XCTAssertEqual(regNameValue, "Ferdinand")

        guard case .genericItem(let regEmailKey, let regEmailValue) = softwareLicense.secureItems[5] else {
            return XCTFail()
        }

        XCTAssertEqual(regEmailKey, "reg_email")
        XCTAssertEqual(regEmailValue, "ferdinand@lizens.com")

        guard case .genericItem(let companyKey, let companyValue) = softwareLicense.secureItems[6] else {
            return XCTFail()
        }

        XCTAssertEqual(companyKey, "company")
        XCTAssertEqual(companyValue, "Super Corp")

        guard case .genericItem(let unsetKey2, let unsetValue2) = softwareLicense.secureItems[7] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey2, "5C1116933D35474FA0AB4DBEFC9ED37A")
        XCTAssertEqual(unsetValue2, "isahdfihsadfihs")

        guard case .genericItem(let downloadLinkKey, let downloadLinkValue) = softwareLicense.secureItems[8] else {
            return XCTFail()
        }

        XCTAssertEqual(downloadLinkKey, "download_link")
        XCTAssertEqual(downloadLinkValue, "bla.com")

        guard case .genericItem(let publisherNameKey, let publisherNameValue) = softwareLicense.secureItems[9] else {
            return XCTFail()
        }

        XCTAssertEqual(publisherNameKey, "publisher_name")
        XCTAssertEqual(publisherNameValue, "bla2.com")

        guard case .genericItem(let publisherWebsiteKey, let publisherWebsiteValue) = softwareLicense.secureItems[10] else {
            return XCTFail()
        }

        XCTAssertEqual(publisherWebsiteKey, "publisher_website")
        XCTAssertEqual(publisherWebsiteValue, "bla3.com")

        guard case .genericItem(let retailPriceKey, let retailPriceValue) = softwareLicense.secureItems[11] else {
            return XCTFail()
        }

        XCTAssertEqual(retailPriceKey, "retail_price")
        XCTAssertEqual(retailPriceValue, "99,99")

        guard case .genericItem(let supportEmailKey, let supportEmailValue) = softwareLicense.secureItems[12] else {
            return XCTFail()
        }

        XCTAssertEqual(supportEmailKey, "support_email")
        XCTAssertEqual(supportEmailValue, "software@lizenz.com")

        guard case .genericItem(let unsetKey3, let unsetValue3) = softwareLicense.secureItems[13] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey3, "1C00993213EC45A8B5B1B9156FA1D399")
        XCTAssertEqual(unsetValue3, "ihsadfihsdfsd")

        guard case .genericItem(let orderDateKey, let orderDateValue) = softwareLicense.secureItems[14] else {
            return XCTFail()
        }

        XCTAssertEqual(orderDateKey, "order_date")
        XCTAssertEqual(orderDateValue, "1589630460")

        guard case .genericItem(let orderNumberKey, let orderNumberValue) = softwareLicense.secureItems[15] else {
            return XCTFail()
        }

        XCTAssertEqual(orderNumberKey, "order_number")
        XCTAssertEqual(orderNumberValue, "1")

        guard case .genericItem(let orderTotalKey, let orderTotalValue) = softwareLicense.secureItems[16] else {
            return XCTFail()
        }

        XCTAssertEqual(orderTotalKey, "order_total")
        XCTAssertEqual(orderTotalValue, "2")

        guard case .genericItem(let unsetKey4, let unsetValue4) = softwareLicense.secureItems[17] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey4, "DA6442670406411EB324D708B38DC828")
        XCTAssertEqual(unsetValue4, "2")

        guard case .genericItem(let unsetKey5, let unsetValue5) = softwareLicense.secureItems[18] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey5, "BF7D28EDA9F74C7281745B0BFA3E2B2C")
        XCTAssertEqual(unsetValue5, "3")

    }
    
    func testCompanyPass() throws {
        let companyPass = result[11]
        
        XCTAssertEqual(companyPass.title, "Firmenpass")
        
        guard case .note(let note) = companyPass.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "i am your company pass")
        
        guard case .genericItem(let companyNameKey, let companyNameValue) = companyPass.secureItems[1] else {
            return XCTFail()
        }

        XCTAssertEqual(companyNameKey, "company_name")
        XCTAssertEqual(companyNameValue, "Super Duper Corp")

        guard case .genericItem(let memberNameKey, let memberNameValue) = companyPass.secureItems[2] else {
            return XCTFail()
        }

        XCTAssertEqual(memberNameKey, "member_name")
        XCTAssertEqual(memberNameValue, "Ferdinand Passmeier")

        guard case .genericItem(let membershipNoKey, let membershipNoValue) = companyPass.secureItems[3] else {
            return XCTFail()
        }

        XCTAssertEqual(membershipNoKey, "membership_no")
        XCTAssertEqual(membershipNoValue, "1234123123")

        guard case .genericItem(let pinKey, let pinValue) = companyPass.secureItems[4] else {
            return XCTFail()
        }

        XCTAssertEqual(pinKey, "pin")
        XCTAssertEqual(pinValue, "iamthepassword")

        guard case .genericItem(let unsetKey, let unsetValue) = companyPass.secureItems[5] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey, "22CBA29BDAEF411783ECA0C4474843DD")
        XCTAssertEqual(unsetValue, "ihadsfhasufaisf")

        guard case .genericItem(let additionalNoKey, let additionalNoValue) = companyPass.secureItems[6] else {
            return XCTFail()
        }

        XCTAssertEqual(additionalNoKey, "additional_no")
        XCTAssertEqual(additionalNoValue, "11111")

        guard case .genericItem(let memberSinceKey, let memberSinceValue) = companyPass.secureItems[7] else {
            return XCTFail()
        }

        XCTAssertEqual(memberSinceKey, "member_since")
        XCTAssertEqual(memberSinceValue, "201902")

        guard case .genericItem(let customerServicePhoneKey, let customerServicePhoneValue) = companyPass.secureItems[8] else {
            return XCTFail()
        }

        XCTAssertEqual(customerServicePhoneKey, "customer_service_phone")
        XCTAssertEqual(customerServicePhoneValue, "917129111")

        guard case .genericItem(let reservationsPhoneKey, let reservationsPhoneValue) = companyPass.secureItems[9] else {
            return XCTFail()
        }

        XCTAssertEqual(reservationsPhoneKey, "reservations_phone")
        XCTAssertEqual(reservationsPhoneValue, "3234234")

        guard case .genericItem(let websiteKey, let websiteValue) = companyPass.secureItems[10] else {
            return XCTFail()
        }

        XCTAssertEqual(websiteKey, "website")
        XCTAssertEqual(websiteValue, "firma.com")

        guard case .genericItem(let unsetKey2, let unsetValue2) = companyPass.secureItems[11] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey2, "314584BABD85454B9C85F1EB98266310")
        XCTAssertEqual(unsetValue2, "iahasfihasf")
    }
    
    func testWLANRouter() throws {
        let wlanRouter = result[12]
        
        XCTAssertEqual(wlanRouter.title, "WLAN-Router")
        
        guard case .note(let note) = wlanRouter.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "I am the wifi router")
        
        guard case .genericItem(let nameKey, let nameValue) = wlanRouter.secureItems[1] else {
            return XCTFail()
        }

        XCTAssertEqual(nameKey, "name")
        XCTAssertEqual(nameValue, "Wifi Station")

        guard case .genericItem(let passwordKey, let passwordValue) = wlanRouter.secureItems[2] else {
            return XCTFail()
        }

        XCTAssertEqual(passwordKey, "password")
        XCTAssertEqual(passwordValue, "09182490128309128949182048012490124")

        guard case .genericItem(let serverKey, let serverValue) = wlanRouter.secureItems[3] else {
            return XCTFail()
        }

        XCTAssertEqual(serverKey, "server")
        XCTAssertEqual(serverValue, "192.168.1.1")

        guard case .genericItem(let aidportIdKey, let aidportIdValue) = wlanRouter.secureItems[4] else {
            return XCTFail()
        }

        XCTAssertEqual(aidportIdKey, "airport_id")
        XCTAssertEqual(aidportIdValue, "21")

        guard case .genericItem(let networkNameKey, let networkNameValue) = wlanRouter.secureItems[5] else {
            return XCTFail()
        }

        XCTAssertEqual(networkNameKey, "network_name")
        XCTAssertEqual(networkNameValue, "Super Lan")

        guard case .genericItem(let wirelessSecurityKey, let wirelessSecurityValue) = wlanRouter.secureItems[6] else {
            return XCTFail()
        }

        XCTAssertEqual(wirelessSecurityKey, "wireless_security")
        XCTAssertEqual(wirelessSecurityValue, "wpa2e")

        guard case .genericItem(let wirelessPasswordKey, let wirelessPasswordValue) = wlanRouter.secureItems[7] else {
            return XCTFail()
        }

        XCTAssertEqual(wirelessPasswordKey, "wireless_password")
        XCTAssertEqual(wirelessPasswordValue, "jaidsfhasifhasashfiasf")

        guard case .genericItem(let diskPasswordKey, let diskPasswordValue) = wlanRouter.secureItems[8] else {
            return XCTFail()
        }

        XCTAssertEqual(diskPasswordKey, "disk_password")
        XCTAssertEqual(diskPasswordValue, "asfasfasfasfasfasfasf")
    }
    
    func testLogin() throws {
        let login = result[13]
        
        XCTAssertEqual(login.title, "Login")
        
        guard case .login(let username, let password) = login.secureItems[0] else {
            return XCTFail()
        }
        
        XCTAssertEqual(username, "username")
        XCTAssertEqual(password, "password")
    }
    
    func testSecureNote() throws {
        let secureNote = result[14]
        
        XCTAssertEqual(secureNote.title, "Sichere Notiz")
        
        guard case .note(let note) = secureNote.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut nec arcu elementum, auctor magna suscipit, porta elit. Phasellus nec egestas odio. Donec ullamcorper ornare libero, in laoreet mi consectetur vel. Praesent massa lorem, suscipit ornare maximus non, condimentum eu massa. Praesent congue tellus at quam efficitur, eu suscipit lorem molestie. Nam fringilla suscipit odio sed vehicula. Etiam dapibus a orci nec pharetra. Praesent eros nibh, dapibus et convallis non, pellentesque vitae arcu. Mauris quis justo suscipit, fringilla nibh a, convallis urna.")
        
        guard case .genericItem(let unsetKey, let unsetValue) = secureNote.secureItems[1] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey, "A9F4AB076D2944908AC63B957BEF777E")
        XCTAssertEqual(unsetValue, "asfasfasf")

        guard case .genericItem(let unsetKey2, let unsetValue2) = secureNote.secureItems[2] else {
            return XCTFail()
        }


        XCTAssertEqual(unsetKey2, "BCFB43A7E57A41349F406284F634A188")
        XCTAssertEqual(unsetValue2, "dfdddsdfsdfssssdddd")

        guard case .genericItem(let unsetKey3, let unsetValue3) = secureNote.secureItems[3] else {
            return XCTFail()
        }


        XCTAssertEqual(unsetKey3, "0AB7F17AF8BC454F85D30FD6F093234C")
        XCTAssertEqual(unsetValue3, "iadhsihasfiahsfiasf")
    }
    
    func testCreditCard() throws {
        let creditCard = result[15]
        
        XCTAssertEqual(creditCard.title, "Kreditkarte")
        
        guard case .note(let note) = creditCard.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "Meine Kreditkarte")
        
        guard case .genericItem(let cardholderKey, let cardholderValue) = creditCard.secureItems[1] else {
            return XCTFail()
        }

        XCTAssertEqual(cardholderKey, "cardholder")
        XCTAssertEqual(cardholderValue, "Max Mustermann")

        guard case .genericItem(let typeKey, let typeValue) = creditCard.secureItems[2] else {
            return XCTFail()
        }

        XCTAssertEqual(typeKey, "type")
        XCTAssertEqual(typeValue, "amex")

        guard case .genericItem(let ccnumKey, let ccnumValue) = creditCard.secureItems[3] else {
            return XCTFail()
        }

        XCTAssertEqual(ccnumKey, "ccnum")
        XCTAssertEqual(ccnumValue, "545451548451845184518548158")

        guard case .genericItem(let cvvKey, let cvvValue) = creditCard.secureItems[4] else {
            return XCTFail()
        }

        XCTAssertEqual(cvvKey, "cvv")
        XCTAssertEqual(cvvValue, "432")

        guard case .genericItem(let expiryKey, let expiryValue) = creditCard.secureItems[5] else {
            return XCTFail()
        }

        XCTAssertEqual(expiryKey, "expiry")
        XCTAssertEqual(expiryValue, "202504")

        guard case .genericItem(let validFromKey, let validFromValue) = creditCard.secureItems[6] else {
            return XCTFail()
        }

        XCTAssertEqual(validFromKey, "validFrom")
        XCTAssertEqual(validFromValue, "208001")

        guard case .genericItem(let unsetKey, let unsetValue) = creditCard.secureItems[7] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey, "AE92530D6192462197D7300FBAE6B862")
        XCTAssertEqual(unsetValue, "gdsfgdfgdfgdfg")

        guard case .genericItem(let bankKey, let bankValue) = creditCard.secureItems[8] else {
            return XCTFail()
        }

        XCTAssertEqual(bankKey, "bank")
        XCTAssertEqual(bankValue, "Volksbank")

        guard case .genericItem(let phoneLocalKey, let phoneLocalValue) = creditCard.secureItems[9] else {
            return XCTFail()
        }

        XCTAssertEqual(phoneLocalKey, "phoneLocal")
        XCTAssertEqual(phoneLocalValue, "012319012391")

        guard case .genericItem(let phoneTollFreeKey, let phoneTollFreeValue) = creditCard.secureItems[10] else {
            return XCTFail()
        }

        XCTAssertEqual(phoneTollFreeKey, "phoneTollFree")
        XCTAssertEqual(phoneTollFreeValue, "12491291919")

        guard case .genericItem(let phoneIntlKey, let phoneIntlValue) = creditCard.secureItems[11] else {
            return XCTFail()
        }

        XCTAssertEqual(phoneIntlKey, "phoneIntl")
        XCTAssertEqual(phoneIntlValue, "89127481")

        guard case .genericItem(let websiteKey, let websiteValue) = creditCard.secureItems[12] else {
            return XCTFail()
        }

        XCTAssertEqual(websiteKey, "website")
        XCTAssertEqual(websiteValue, "volksbank.com")

        guard case .genericItem(let unsetKey2, let unsetValue2) = creditCard.secureItems[13] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey2, "3A210E10EE0E42CB9F5111D814E76CB2")
        XCTAssertEqual(unsetValue2, "ihsaduihsdfisdf")

        guard case .genericItem(let pinKey, let pinValue) = creditCard.secureItems[14] else {
            return XCTFail()
        }

        XCTAssertEqual(pinKey, "pin")
        XCTAssertEqual(pinValue, "123123")

        guard case .genericItem(let creditLimitKey, let creditLimitValue) = creditCard.secureItems[15] else {
            return XCTFail()
        }

        XCTAssertEqual(creditLimitKey, "creditLimit")
        XCTAssertEqual(creditLimitValue, "3500")

        guard case .genericItem(let cashLimitKey, let cashLimitValue) = creditCard.secureItems[16] else {
            return XCTFail()
        }

        XCTAssertEqual(cashLimitKey, "cashLimit")
        XCTAssertEqual(cashLimitValue, "250")

        guard case .genericItem(let interestKey, let interestValue) = creditCard.secureItems[17] else {
            return XCTFail()
        }

        XCTAssertEqual(interestKey, "interest")
        XCTAssertEqual(interestValue, "0,2")

        guard case .genericItem(let issuenumberKey, let issuenumberValue) = creditCard.secureItems[18] else {
            return XCTFail()
        }

        XCTAssertEqual(issuenumberKey, "issuenumber")
        XCTAssertEqual(issuenumberValue, "9191201")
    }
    
    func testUniqueIdentifier() throws {
        let uniqueIdentifier = result[16]

        XCTAssertEqual(uniqueIdentifier.title, "unique_identifier")

        guard case .login(let username, let password) = uniqueIdentifier.secureItems[0] else {
           return XCTFail()
        }

        XCTAssertEqual(username, "username")
        XCTAssertEqual(password, "password")
        
        guard case .genericItem(let unsetKey, let unsetValue) = uniqueIdentifier.secureItems[1] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey, "DDCABE2A8E3A455DB2B94957F8E87DC6")
        XCTAssertEqual(unsetValue, "custom data")

        guard case .genericItem(let unsetKey2, let unsetValue2) = uniqueIdentifier.secureItems[2] else {
            return XCTFail()
        }


        XCTAssertEqual(unsetKey2, "63D160B3F540498D9EF1839258CF31E7")
        XCTAssertEqual(unsetValue2, "other password")

        guard case .genericItem(let unsetKey3, let unsetValue3) = uniqueIdentifier.secureItems[3] else {
            return XCTFail()
        }


        XCTAssertEqual(unsetKey3, "BC85BF067BB3407085FBF4E9155B9A22")
        XCTAssertEqual(unsetValue3, "Supergeheim")
       }
    
    func testIdentify() throws {
        let identifier = result[17]
        
        XCTAssertEqual(identifier.title, "Identität")
        
        guard case .note(let note) = identifier.secureItems[0] else {
           return XCTFail()
        }
        XCTAssertEqual(note, "das hier ist meine identität")
     

        guard case .genericItem(let firstnameKey, let firstnameValue) = identifier.secureItems[1] else {
            return XCTFail()
        }

        XCTAssertEqual(firstnameKey, "firstname")
        XCTAssertEqual(firstnameValue, "Mrs Identity")

        guard case .genericItem(let initialKey, let initialValue) = identifier.secureItems[2] else {
            return XCTFail()
        }

        XCTAssertEqual(initialKey, "initial")
        XCTAssertEqual(initialValue, "MI")

        guard case .genericItem(let lastnameKey, let lastnameValue) = identifier.secureItems[3] else {
            return XCTFail()
        }

        XCTAssertEqual(lastnameKey, "lastname")
        XCTAssertEqual(lastnameValue, "Identity")

        guard case .genericItem(let sexKey, let sexValue) = identifier.secureItems[4] else {
            return XCTFail()
        }

        XCTAssertEqual(sexKey, "sex")
        XCTAssertEqual(sexValue, "female")

        guard case .genericItem(let birthdateKey, let birthdateValue) = identifier.secureItems[5] else {
            return XCTFail()
        }

        XCTAssertEqual(birthdateKey, "birthdate")
        XCTAssertEqual(birthdateValue, "1587643260")

        guard case .genericItem(let occupationKey, let occupationValue) = identifier.secureItems[6] else {
            return XCTFail()
        }

        XCTAssertEqual(occupationKey, "occupation")
        XCTAssertEqual(occupationValue, "Zahnchirurg")

        guard case .genericItem(let companyKey, let companyValue) = identifier.secureItems[7] else {
            return XCTFail()
        }

        XCTAssertEqual(companyKey, "company")
        XCTAssertEqual(companyValue, "Zahnchirurg AG")

        guard case .genericItem(let departmentKey, let departmentValue) = identifier.secureItems[8] else {
            return XCTFail()
        }

        XCTAssertEqual(departmentKey, "department")
        XCTAssertEqual(departmentValue, "1")

        guard case .genericItem(let jobtitleKey, let jobtitleValue) = identifier.secureItems[9] else {
            return XCTFail()
        }

        XCTAssertEqual(jobtitleKey, "jobtitle")
        XCTAssertEqual(jobtitleValue, "Chefzahnklempner")

        guard case .genericItem(let unsetKey, let unsetValue) = identifier.secureItems[10] else {
            return XCTFail()
        }

        XCTAssertEqual(unsetKey, "A16E62F369E24CE2B965DE7F0FA6CD6D")
        XCTAssertEqual(unsetValue, "asifhasifhiasf")

        guard case .genericItem(let addressKey, let addressValue) = identifier.secureItems[11] else {
            return XCTFail()
        }

        XCTAssertEqual(addressKey, "address")
        XCTAssertEqual(addressValue, "Zahnhausen, de, Mainstreet 2, 64114")

        guard case .genericItem(let defphoneKey, let defphoneValue) = identifier.secureItems[12] else {
            return XCTFail()
        }

        XCTAssertEqual(defphoneKey, "defphone")
        XCTAssertEqual(defphoneValue, "34212341234")

        guard case .genericItem(let homephoneKey, let homephoneValue) = identifier.secureItems[13] else {
            return XCTFail()
        }

        XCTAssertEqual(homephoneKey, "homephone")
        XCTAssertEqual(homephoneValue, "23412111212")

        guard case .genericItem(let cellphoneKey, let cellphoneValue) = identifier.secureItems[14] else {
            return XCTFail()
        }

        XCTAssertEqual(cellphoneKey, "cellphone")
        XCTAssertEqual(cellphoneValue, "2341214141")

        guard case .genericItem(let busphoneKey, let busphoneValue) = identifier.secureItems[15] else {
            return XCTFail()
        }

        XCTAssertEqual(busphoneKey, "busphone")
        XCTAssertEqual(busphoneValue, "23412412413")

        guard case .genericItem(let usernameKey, let usernameValue) = identifier.secureItems[16] else {
            return XCTFail()
        }

        XCTAssertEqual(usernameKey, "username")
        XCTAssertEqual(usernameValue, "Zahnfee")

        guard case .genericItem(let reminderqKey, let reminderqValue) = identifier.secureItems[17] else {
            return XCTFail()
        }

        XCTAssertEqual(reminderqKey, "reminderq")
        XCTAssertEqual(reminderqValue, "Was ist mein Passwort?")

        guard case .genericItem(let reminderaKey, let reminderaValue) = identifier.secureItems[18] else {
            return XCTFail()
        }

        XCTAssertEqual(reminderaKey, "remindera")
        XCTAssertEqual(reminderaValue, "Was ist nicht mein Passwort?")

        guard case .genericItem(let emailKey, let emailValue) = identifier.secureItems[19] else {
            return XCTFail()
        }

        XCTAssertEqual(emailKey, "email")
        XCTAssertEqual(emailValue, "zahnfee@zahnglobal.de")

        guard case .genericItem(let websiteKey, let websiteValue) = identifier.secureItems[20] else {
            return XCTFail()
        }

        XCTAssertEqual(websiteKey, "website")
        XCTAssertEqual(websiteValue, "zahnglobal.de")

        guard case .genericItem(let icqKey, let icqValue) = identifier.secureItems[21] else {
            return XCTFail()
        }

        XCTAssertEqual(icqKey, "icq")
        XCTAssertEqual(icqValue, "20138429382")

        guard case .genericItem(let skypeKey, let skypeValue) = identifier.secureItems[22] else {
            return XCTFail()
        }

        XCTAssertEqual(skypeKey, "skype")
        XCTAssertEqual(skypeValue, "@zahnfee")

        guard case .genericItem(let aimKey, let aimValue) = identifier.secureItems[23] else {
            return XCTFail()
        }

        XCTAssertEqual(aimKey, "aim")
        XCTAssertEqual(aimValue, "01241024")

        guard case .genericItem(let yahooKey, let yahooValue) = identifier.secureItems[24] else {
            return XCTFail()
        }

        XCTAssertEqual(yahooKey, "yahoo")
        XCTAssertEqual(yahooValue, "0101010")

        guard case .genericItem(let msnKey, let msnValue) = identifier.secureItems[25] else {
            return XCTFail()
        }

        XCTAssertEqual(msnKey, "msn")
        XCTAssertEqual(msnValue, "1022410241")

        guard case .genericItem(let forumsigKey, let forumsigValue) = identifier.secureItems[26] else {
            return XCTFail()
        }

        XCTAssertEqual(forumsigKey, "forumsig")
        XCTAssertEqual(forumsigValue, "w9018349234928393213")
    }
       
}

let testImport = #"""
{"uuid":"1D81C2A9F86142F99AE2D8C575E37BD0","updatedAt":1592921145,"securityLevel":"SL5","openContents":{"tags":["leckerjagen","jagdschein"]},"contentsHash":"4e3858c8","title":"Jagdschein","secureContents":{"state":"Bayern","expires_dd":"14","valid_from_mm":"6","valid_from_yy":"2020","valid_from_dd":"18","expires_yy":"2020","expires_mm":"3","sections":[{"fields":[{"k":"string","v":"Ferdinand Kühne","n":"name","inputTraits":{"autocapitalization":"Words"},"t":"Vollständiger Name"},{"k":"date","n":"valid_from","v":1592481660,"t":"Gültig ab"},{"k":"date","n":"expires","v":1584187260,"t":"Gültig bis"},{"k":"string","v":"Hirsch, Iltis, Grottenolm","n":"game","inputTraits":{"autocapitalization":"Words"},"t":"Freigegebene Wildtiere"},{"k":"string","n":"quota","v":"1","t":"Höchstquote"},{"k":"string","v":"Bayern","n":"state","inputTraits":{"autocapitalization":"Words"},"t":"Bundesland\/Kanton"},{"k":"string","v":"Germany","n":"country","inputTraits":{"autocapitalization":"Words"},"t":"Land"},{"k":"string","n":"122AA14967774EE1BE8B370308B1827A","v":"Mainstreet 99","t":""},{"k":"string","n":"BC9DF508BA004F7EBEDE5D624E36473F","v":"73829 Grottenolmhausen","t":""}],"title":"","name":""},{"title":"Verwandte Objekte","name":"linked items"},{"fields":[{"k":"string","n":"B9E78EAAF5AE4F4E822087D1533BFD1A","v":"asfascascasfasf","t":""},{"k":"string","n":"E276D5380E304B648CB451EB66761C71","v":"afaasfasrraxdcvadf","t":""},{"k":"email","n":"9B265842297645889A323D20AEEB38EA","v":"ersdvsaesd","t":""}],"title":"","name":"Section_405405C9069B4416A92E9AFA2F80B58B"},{"fields":[{"k":"string","n":"EAAB875F0A5044529C3B488D4DA179A9","v":"bxdfwqaresg","t":""}],"title":"","name":"Section_58390E8AA07F4B96943083E95FC4C22B"}],"notesPlain":"Mein Jagdschein","game":"Hirsch, Iltis, Grottenolm","quota":"1","name":"Ferdinand Kühne","country":"Germany"},"txTimestamp":1592921145,"createdAt":1589277452,"typeName":"wallet.government.HuntingLicense"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"D3ADFE450E3F4CB88525B65945B08782","updatedAt":1592921700,"securityLevel":"SL5","contentsHash":"fad38ac0","title":"Passwort","secureContents":{"password":"iamsecretpassword","passwordHistory":[{"value":"dfsdgfsdfsdfsdfsd","time":1592921700}],"notesPlain":"i am your password","sections":[{"fields":[{"k":"string","n":"D19B5C84C1054EB7BCD648C56672EF1F","v":"asfasfasfasfa","t":"sdgsdg"},{"k":"string","n":"E174AFCAE0C0411DB1EF8504397F0414","v":"fghdgfd","t":"ssssss"},{"k":"string","n":"B2080ADEB50A4AE7AD8334D0AD476C9F","v":"xbcdvbdfdfg","t":"Passwort"}],"title":"","name":"Section_625E641A95564C22BB8F847C9B906F8A"},{"title":"Verwandte Objekte","name":"linked items"},{"fields":[{"k":"string","n":"55A17E30FC9C451BB457AF22A31C702C","v":"dfgdgdfg","t":""}],"title":"dfgdfgdfgdf","name":"Section_035F579FB26F4141BC591F0DF4C24055"},{"fields":[{"k":"string","n":"9F19915367E442318518E7EAA8050B7F","v":"dfgdfgdfgdf","t":"Passwort"}],"title":"ddfdfgdfgdfg","name":"Section_DD29ACEF708A47BA8539CD741DE4D51F"}]},"txTimestamp":1592921700,"createdAt":1589286458,"typeName":"passwords.Password"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"4E7F0CA0B2994C44A345C51EB10EE858","updatedAt":1592921970,"securityLevel":"SL5","openContents":{"tags":["ferdinand","dreisine"]},"contentsHash":"d34cdbe","title":"Passierschein","secureContents":{"birthdate_yy":"2020","state":"Bayern","birthdate_mm":"6","expiry_date_mm":"2","birthdate_dd":"23","sections":[{"fields":[{"k":"string","v":"Ferdinand","n":"fullname","inputTraits":{"autocapitalization":"words"},"t":"Vollständiger Name"},{"k":"string","v":"","n":"address","inputTraits":{"autocapitalization":"sentences"},"t":"Adresse"},{"k":"date","n":"birthdate","v":1592913660,"t":"Geburtsdatum"},{"k":"gender","n":"sex","t":"Geschlecht"},{"k":"string","n":"height","v":"1.97","t":"Größe"},{"k":"string","n":"number","v":"010101281231","t":"Nummer"},{"k":"string","n":"class","v":"B","t":"Führerscheinklasse"},{"k":"string","n":"conditions","v":"Keine Dreisine","t":"Bedingungen \/ Beschränkungen"},{"k":"string","n":"state","v":"Bayern","t":"Bundesland \/ Kanton"},{"k":"string","n":"country","v":"","t":"Land"},{"k":"monthYear","n":"expiry_date","v":202002,"t":"Gültigkeitsdatum"},{"k":"string","n":"017662C81DF043BC9265EF5FF510DB54","v":"12012340123","t":"hifghdifgh"},{"k":"string","n":"8D07140CD8F542E1B754D449BC9ADB0C","v":"kajsfkasjfkasf","t":""}],"title":"","name":""},{"title":"Verwandte Objekte","name":"linked items"},{"fields":[{"k":"string","n":"5EFA80AC728A460F8E3CCD474A18141C","v":"kasdjfgkshdkgsd","t":""}],"title":"","name":"Section_14C23199CB084972AF14432EC8AB2FF3"}],"conditions":"Keine Dreisine","notesPlain":"Dies ist der Passierschein","number":"010101281231","height":"1.97","expiry_date_yy":"2020","fullname":"Ferdinand","class":"B"},"txTimestamp":1592921970,"createdAt":1589277564,"typeName":"wallet.government.DriversLicense"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"F0BA3E28D57C4415B8B4FF128BFF23F3","updatedAt":1592919926,"securityLevel":"SL5","openContents":{"tags":["super_datenbank","datenbank"]},"contentsHash":"b5bfe896","title":"SQL","secureContents":{"database_type":"mysql","options":"connector1","passwordHistory":[{"value":"asfasfasfasf","time":1592919926}],"hostname":"super_server","sections":[{"fields":[{"k":"menu","n":"database_type","v":"mysql","t":"Typ"},{"k":"string","v":"super_server","n":"hostname","inputTraits":{"keyboard":"URL"},"t":"Server"},{"k":"string","v":"12","n":"port","inputTraits":{"keyboard":"NumberPad"},"t":"Port"},{"k":"string","v":"SQL 1.2","n":"database","inputTraits":{"autocorrection":"no","autocapitalization":"none"},"t":"Datenbank"},{"k":"string","v":"Dr Database","n":"username","inputTraits":{"autocorrection":"no","autocapitalization":"none"},"t":"Benutzername"},{"k":"concealed","n":"password","v":"database_password","t":"Passwort"},{"k":"string","n":"sid","v":"9181821301","t":"SID"},{"k":"string","n":"alias","v":"12124121411","t":"Alias"},{"k":"string","n":"options","v":"connector1","t":"Verbindungsoptionen"},{"k":"string","n":"90F2F12507504DAEB2358309280EB95A","v":"connector2","t":""}],"title":"","name":""},{"title":"Verwandte Objekte","name":"linked items"},{"fields":[{"k":"string","n":"9A1753DF7E0649FDAC0F26B589AF2373","v":"jakfsjasakjasf","t":""}],"title":"","name":"Section_F5CEF60CCF854FF48448E99765C6BCFF"}],"notesPlain":"very important database","password":"database_password","sid":"9181821301","alias":"12124121411","username":"Dr Database","database":"SQL 1.2","port":"12"},"txTimestamp":1592919926,"createdAt":1589287228,"typeName":"wallet.computer.Database"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"CA2E293EA8AF44D4BBAD4AE272AC88D2","updatedAt":1592919646,"securityLevel":"SL5","openContents":{"scope":"Never","tags":["Konto","Bankkonto"]},"contentsHash":"99c42bc3","title":"Bankkonto","secureContents":{"accountNo":"22671794","passwordHistory":[{"value":"asfasf","time":1592919470}],"branchPhone":"081234911","bankName":"Volksbank","owner":"Max Mustermann","routingNo":"678199200","swift":"00 31 71 582 2822","iban":"NL15ABNA5172064443","sections":[{"fields":[{"k":"string","v":"Volksbank","n":"bankName","inputTraits":{"autocapitalization":"Words"},"t":"Bankname"},{"k":"string","v":"Max Mustermann","n":"owner","inputTraits":{"autocapitalization":"Words"},"t":"Kontoinhaber"},{"k":"menu","n":"accountType","v":"savings","t":"Typ"},{"k":"string","v":"678199200","n":"routingNo","inputTraits":{"keyboard":"NumbersAndPunctuation"},"t":"BLZ"},{"k":"string","v":"22671794","n":"accountNo","inputTraits":{"keyboard":"NumbersAndPunctuation"},"t":"Kontonummer"},{"k":"string","v":"00 31 71 582 2822","n":"swift","inputTraits":{"keyboard":"NumbersAndPunctuation"},"t":"SWIFT"},{"k":"string","v":"NL15ABNA5172064443","n":"iban","inputTraits":{"keyboard":"NumbersAndPunctuation"},"t":"IBAN"},{"k":"concealed","inputTraits":{"keyboard":"NumberPad"},"n":"telephonePin","v":"1238","a":{"generate":"off"},"t":"PIN"},{"k":"string","n":"4EA7F91E251B4F2FA3624F7938C78482","v":"jsadfjis","t":""}],"title":"","name":""},{"fields":[{"k":"phone","v":"081234911","n":"branchPhone","inputTraits":{"keyboard":"NamePhonePad"},"t":"Telefon"},{"k":"string","v":"1 Mainstreet","n":"branchAddress","inputTraits":{"autocapitalization":"Sentences"},"t":"Adresse"}],"title":"Filiale","name":"branchInfo"},{"title":"Verwandte Objekte","name":"linked items"}],"accountType":"savings","notesPlain":"Mein liebstes Bankkonto","telephonePin":"1238","branchAddress":"1 Mainstreet"},"txTimestamp":1592919646,"createdAt":1589287260,"typeName":"wallet.financial.BankAccountUS"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"492C3354D0084EE8AE32C464C7AA3672","updatedAt":1592921673,"securityLevel":"SL5","openContents":{"tags":["peta"]},"contentsHash":"7a3042fc","title":"Mitgliedschaft","secureContents":{"org_name":"PETA","phone":"0123121121","passwordHistory":[{"value":"sdfsdfsdf","time":1592921673}],"expiry_date_mm":"12","member_name":"Ferdinand","member_since_mm":"5","membership_no":"122","sections":[{"fields":[{"k":"string","v":"PETA","n":"org_name","inputTraits":{"autocapitalization":"Words"},"t":"Organisation"},{"k":"URL","n":"website","v":"peta.com","t":"Webseite"},{"k":"phone","n":"phone","v":"0123121121","t":"Telefon"},{"k":"string","v":"Ferdinand","n":"member_name","inputTraits":{"autocapitalization":"Words"},"t":"Mitgliedsname"},{"k":"monthYear","n":"member_since","v":202005,"t":"Mitglied seit"},{"k":"monthYear","n":"expiry_date","v":200112,"t":"Gültigkeitsdatum"},{"k":"string","v":"122","n":"membership_no","inputTraits":{"autocorrection":"no"},"t":"Mitglieds-Nr."},{"k":"concealed","v":"password","n":"pin","inputTraits":{"keyboard":"NumberPad"},"t":"Passwort"},{"k":"string","n":"2064D0B78411437EAA90AC9E49016836","v":"adsgadsgadsg","t":""}],"title":"","name":""},{"title":"Verwandte Objekte","name":"linked items"},{"fields":[{"k":"string","n":"927CB1C6966842DD8FC9C76FD36F5F42","v":"sdgsdgsdg","t":""}],"title":"","name":"Section_A763F2FEDC9441DE892B172D33EA956E"}],"member_since_yy":"2020","expiry_date_yy":"2001","pin":"password","website":"peta.com"},"txTimestamp":1592921673,"createdAt":1589287326,"typeName":"wallet.membership.Membership"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"6FA98B8016E44B80B049FF893812E995","updatedAt":1592920045,"securityLevel":"SL5","contentsHash":"7eb25862","title":"E-Mail-Konto","secureContents":{"smtp_username":"Prof Email","smtp_password":"mailingpassword","passwordHistory":[{"value":"sdfsdfsdf","time":1592920032}],"smtp_port":"1231","smtp_security":"SSL","sections":[{"fields":[{"k":"menu","n":"pop_type","v":"imap","t":"Typ"},{"k":"string","v":"Dr Email","n":"pop_username","inputTraits":{"autocorrection":"no","autocapitalization":"none"},"t":"Benutzername"},{"k":"string","v":"xafsoajsf","n":"pop_server","inputTraits":{"keyboard":"URL"},"t":"Server"},{"k":"string","v":"222","n":"pop_port","inputTraits":{"keyboard":"NumberPad"},"t":"Portnummer"},{"k":"concealed","n":"pop_password","v":"emailapssword","t":"Passwort"},{"k":"menu","n":"pop_security","v":"SSL","t":"Sicherheit"},{"k":"menu","n":"pop_authentication","v":"kerberized_pop","t":"Authentifizierungsmethode"},{"k":"string","n":"596414580AE249F1A7D407AB83376146","v":"ajsfasfasofa","t":""}],"title":"","name":""},{"fields":[{"k":"string","v":"iamsmtpserver","n":"smtp_server","inputTraits":{"keyboard":"URL"},"t":"SMTP-Server"},{"k":"string","v":"1231","n":"smtp_port","inputTraits":{"keyboard":"NumberPad"},"t":"Portnummer"},{"k":"string","v":"Prof Email","n":"smtp_username","inputTraits":{"autocorrection":"no","autocapitalization":"none"},"t":"Benutzername"},{"k":"concealed","n":"smtp_password","v":"mailingpassword","t":"Passwort"},{"k":"menu","n":"smtp_security","v":"SSL","t":"Sicherheit"},{"k":"menu","n":"smtp_authentication","v":"password","t":"Authentifizierungsmethode"},{"k":"string","n":"1725CF4ED5944B658B690896D2A02C0B","v":"iashifhasf","t":""}],"title":"SMTP","name":"SMTP"},{"fields":[{"k":"string","v":"Strato","n":"provider","inputTraits":{"autocapitalization":"Words"},"t":"Anbieter"},{"k":"string","v":"strato.de","n":"provider_website","inputTraits":{"keyboard":"URL"},"t":"Anbieterwebsite"},{"k":"string","v":"0123818181","n":"phone_local","inputTraits":{"keyboard":"NamePhonePad"},"t":"Telefon (lokal)"},{"k":"string","v":"012319111","n":"phone_tollfree","inputTraits":{"keyboard":"NamePhonePad"},"t":"Telefon (gebührenfrei)"},{"k":"string","n":"E680C2D98D2A41639ACA892EEED1417F","v":"ashfiasfhasf","t":""}],"title":"Kontaktdaten","name":"Contact Information"},{"title":"Verwandte Objekte","name":"linked items"},{"fields":[{"k":"string","n":"0232D58F833C40049D6EB63059846BA2","v":"sjasofjasofjaooadfsdf","t":""}],"title":"","name":"Section_D493689C3CBF4BAD8E5872DD1D7E2C95"}],"pop_security":"SSL","phone_tollfree":"012319111","pop_username":"Dr Email","pop_authentication":"kerberized_pop","smtp_server":"iamsmtpserver","pop_password":"emailapssword","smtp_authentication":"password","provider_website":"strato.de","notesPlain":"This is an email account","pop_port":"222","pop_type":"imap","pop_server":"xafsoajsf","provider":"Strato","phone_local":"0123818181"},"txTimestamp":1592920045,"createdAt":1589287285,"typeName":"wallet.onlineservices.Email.v2"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"6A7950B880C74EA6A450D7B00F064EAB","updatedAt":1592922164,"securityLevel":"SL5","openContents":{"tags":["reise","reisepass","deutschland"]},"contentsHash":"470559ed","title":"Reisepass","secureContents":{"issuing_country":"Deutschland","birthdate_yy":"2020","nationality":"Deutschland","birthplace":"234234234","birthdate_mm":"4","sex":"female","expiry_date_mm":"5","birthdate_dd":"18","issue_date_mm":"5","issue_date_yy":"2020","type":"Reisepass","sections":[{"fields":[{"k":"string","v":"Reisepass","n":"type","inputTraits":{"autocapitalization":"AllCharacters"},"t":"Typ"},{"k":"string","v":"Deutschland","n":"issuing_country","inputTraits":{"autocapitalization":"Words"},"t":"Ausstellungsland"},{"k":"string","v":"0101293111","n":"number","inputTraits":{"keyboard":"NamePhonePad"},"t":"Nummer"},{"k":"string","v":"Ferdinand","n":"fullname","inputTraits":{"autocapitalization":"Words"},"t":"Vollständiger Name"},{"k":"gender","n":"sex","v":"female","t":"Geschlecht"},{"k":"string","v":"Deutschland","n":"nationality","inputTraits":{"autocapitalization":"Words"},"t":"Staatsangehörigkeit"},{"k":"string","v":"Deutsches Reisepassamt","n":"issuing_authority","inputTraits":{"autocapitalization":"Words"},"t":"Ausstellende Behörde"},{"k":"date","n":"birthdate","v":1587211260,"t":"Geburtsdatum"},{"k":"string","v":"234234234","n":"birthplace","inputTraits":{"autocapitalization":"Words"},"t":"Geburtsort"},{"k":"date","n":"issue_date","v":1589025660,"t":"Ausgestellt am"},{"k":"date","n":"expiry_date","v":1588939260,"t":"Gültigkeitsdatum"},{"k":"string","n":"4F8F1B9CE2B74380ACEF9E8DE2ABCF04","v":"afasfasfasfasfasf","t":""}],"title":"","name":""},{"title":"Verwandte Objekte","name":"linked items"}],"issue_date_dd":"9","number":"0101293111","expiry_date_dd":"8","expiry_date_yy":"2020","fullname":"Ferdinand","issuing_authority":"Deutsches Reisepassamt"},"txTimestamp":1592922164,"createdAt":1589287347,"typeName":"wallet.government.Passport"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"CCA341B58CBB4228B5D6D042DF1E3857","updatedAt":1592922361,"securityLevel":"SL5","openContents":{"tags":["server","super_datenbank"]},"contentsHash":"4402a1a8","title":"Server","secureContents":{"admin_console_username":"user1","passwordHistory":[{"value":"222","time":1592922361}],"support_contact_url":"server.com\/support","support_contact_phone":"910239123","url":"server.com","admin_console_url":"server.com\/admin","sections":[{"fields":[{"k":"string","v":"server.com","n":"url","inputTraits":{"keyboard":"URL"},"t":"URL"},{"k":"string","v":"server1","n":"username","inputTraits":{"autocorrection":"no","autocapitalization":"none"},"t":"Benutzername"},{"k":"concealed","n":"password","v":"iampassword","t":"Passwort"},{"k":"string","n":"99B56366BF3B4877897A5AC7A8B1131B","v":"adfsdfsdfsdf","t":""}],"title":"","name":""},{"fields":[{"k":"string","v":"server.com\/admin","n":"admin_console_url","inputTraits":{"keyboard":"URL"},"t":"URL der Admin-Konsole"},{"k":"string","v":"user1","n":"admin_console_username","inputTraits":{"autocorrection":"no","autocapitalization":"none"},"t":"Benutzername der Admin-Konsole"},{"k":"concealed","n":"admin_console_password","v":"iampassword","t":"Konsolenpasswort"},{"k":"string","n":"C4EA932A85D14747BB316A814B3F116F","v":"iadshjfiahdsfisd","t":""}],"title":"Admin-Konsole","name":"admin_console"},{"fields":[{"k":"string","v":"Ur Server","n":"name","inputTraits":{"autocapitalization":"Words"},"t":"Name"},{"k":"string","v":"amazingserver.com","n":"website","inputTraits":{"keyboard":"URL"},"t":"Webseite"},{"k":"string","v":"server.com\/support","n":"support_contact_url","inputTraits":{"keyboard":"URL"},"t":"Support-URL"},{"k":"string","v":"910239123","n":"support_contact_phone","inputTraits":{"keyboard":"NamePhonePad"},"t":"Support-Telefon-Nr."},{"k":"string","n":"79633FD4B0E4471890C431E39CF0136A","v":"ojsdfikhsdfihsdf","t":""}],"title":"Hosting-Provider","name":"hosting_provider_details"},{"title":"Verwandte Objekte","name":"linked items"}],"notesPlain":"I am your server","password":"iampassword","username":"server1","admin_console_password":"iampassword","website":"amazingserver.com","name":"Ur Server"},"txTimestamp":1592922361,"createdAt":1589287384,"typeName":"wallet.computer.UnixServer"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"5560B61BA89346519441F602CA074732","updatedAt":1592922555,"securityLevel":"SL5","openContents":{"tags":["ferdinand","sozialversicherungsnummer"]},"contentsHash":"8c57ed35","title":"Sozialversicherungsnummer","secureContents":{"passwordHistory":[{"value":"22333 3wegdsfgdfg","time":1592922555}],"notesPlain":"dies ist meine sozialversicherungsnummer","number":"92378923y429382038423","name":"Ferdinand","sections":[{"fields":[{"k":"string","v":"Ferdinand","n":"name","inputTraits":{"autocapitalization":"Words"},"t":"Name"},{"k":"concealed","inputTraits":{"keyboard":"NumbersAndPunctuation"},"n":"number","v":"92378923y429382038423","a":{"generate":"off"},"t":"Nummer"},{"k":"string","n":"226A17AB8C0941B6AC490B529E401AA1","v":"hsdhfjsdfhjsdf","t":""}],"title":"","name":""},{"title":"Verwandte Objekte","name":"linked items"},{"fields":[{"k":"string","n":"836B9469D2CC4714A38EBBFD42E1DAAA","v":"hsdjfsdhf","t":""}],"title":"ashfsajdhfsdf","name":"Section_050D0DBBC00C49899CBD59A216AE5A44"}]},"txTimestamp":1592922555,"createdAt":1589287458,"typeName":"wallet.government.SsnUS"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"7DFB187360EE462AA02AAED5CBF82A62","updatedAt":1592922505,"securityLevel":"SL5","openContents":{"tags":["lizenz","super_lizenz"]},"contentsHash":"e0984db4","title":"Softwarelizenz","secureContents":{"reg_name":"Ferdinand","order_number":"1","reg_code":"9872394-2930423-8920342034\t","company":"Super Corp","order_date_mm":"5","sections":[{"fields":[{"k":"string","v":"1.2","n":"product_version","inputTraits":{"keyboard":"NumbersAndPunctuation"},"t":"Version"},{"k":"string","v":"9872394-2930423-8920342034\t","n":"reg_code","a":{"guarded":"yes","multiline":"yes"},"t":"Lizenzschlüssel"},{"k":"string","n":"EDD074F3C0974A9B8556EE6BF8B4BF16","v":"4234234","t":""}],"title":"","name":""},{"fields":[{"k":"string","v":"Ferdinand","n":"reg_name","inputTraits":{"autocapitalization":"Words"},"t":"Lizenziert für"},{"k":"email","v":"ferdinand@lizens.com","n":"reg_email","inputTraits":{"keyboard":"EmailAddress"},"t":"Registrierte E-Mail-Adresse"},{"k":"string","v":"Super Corp","n":"company","inputTraits":{"autocapitalization":"Words"},"t":"Firma"},{"k":"string","n":"5C1116933D35474FA0AB4DBEFC9ED37A","v":"isahdfihsadfihs","t":""}],"title":"Kunde","name":"customer"},{"fields":[{"k":"URL","n":"download_link","v":"bla.com","t":"Download-Seite"},{"k":"string","v":"bla2.com","n":"publisher_name","inputTraits":{"autocapitalization":"Words"},"t":"Herausgeber"},{"k":"URL","n":"publisher_website","v":"bla3.com","t":"Webseite"},{"k":"string","v":"99,99","n":"retail_price","inputTraits":{"keyboard":"NumbersAndPunctuation"},"t":"Verkaufspreis"},{"k":"email","v":"software@lizenz.com","n":"support_email","inputTraits":{"autocapitalization":"EmailAddress"},"t":"Support-E-Mail-Adresse"},{"k":"string","n":"1C00993213EC45A8B5B1B9156FA1D399","v":"ihsadfihsdfsd","t":""}],"title":"Herausgeber","name":"publisher"},{"fields":[{"k":"date","n":"order_date","v":1589630460,"t":"Kaufdatum"},{"k":"string","n":"order_number","v":"1","t":"Auftragsnummer"},{"k":"string","v":"2","n":"order_total","inputTraits":{"keyboard":"NumbersAndPunctuation"},"t":"Auftragssumme"},{"k":"string","n":"DA6442670406411EB324D708B38DC828","v":"2","t":""},{"k":"string","n":"BF7D28EDA9F74C7281745B0BFA3E2B2C","v":"3","t":""}],"title":"Auftrag","name":"order"},{"title":"Verwandte Objekte","name":"linked items"}],"support_email":"software@lizenz.com","notesPlain":"dies ist eine firmenlizenz","product_version":"1.2","download_link":"bla.com","order_date_dd":"16","order_date_yy":"2020","publisher_website":"bla3.com","retail_price":"99,99","reg_email":"ferdinand@lizens.com","order_total":"2","publisher_name":"bla2.com"},"txTimestamp":1592922505,"createdAt":1589287414,"typeName":"wallet.computer.License"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"CEA9A449378D4CA59442E3175B101682","updatedAt":1592922270,"securityLevel":"SL5","openContents":{"tags":["firmenpass"]},"contentsHash":"221ac72e","title":"Firmenpass","secureContents":{"passwordHistory":[{"value":"sdgsdgsdg","time":1592922270}],"customer_service_phone":"917129111","member_name":"Ferdinand Passmeier","member_since_mm":"2","membership_no":"1234123123","company_name":"Super Duper Corp","sections":[{"fields":[{"k":"string","v":"Super Duper Corp","n":"company_name","inputTraits":{"autocapitalization":"Words"},"t":"Firmenname"},{"k":"string","v":"Ferdinand Passmeier","n":"member_name","inputTraits":{"autocapitalization":"Words"},"t":"Mitgliedsname"},{"k":"string","inputTraits":{"autocorrection":"no","autocapitalization":"none"},"n":"membership_no","v":"1234123123","a":{"clipboardFilter":"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"},"t":"Mitglieds-Nr."},{"k":"concealed","v":"iamthepassword","n":"pin","inputTraits":{"keyboard":"NumberPad"},"t":"PIN"},{"k":"string","n":"22CBA29BDAEF411783ECA0C4474843DD","v":"ihadsfhasufaisf","t":""}],"title":"","name":""},{"fields":[{"k":"string","v":"11111","n":"additional_no","inputTraits":{"autocorrection":"no","autocapitalization":"none"},"t":"Mitgliedschafts-Nr. (zusätzlich)"},{"k":"monthYear","n":"member_since","v":201902,"t":"Mitglied seit"},{"k":"string","v":"917129111","n":"customer_service_phone","inputTraits":{"keyboard":"NamePhonePad"},"t":"Kundenservicetelefon"},{"k":"phone","v":"3234234","n":"reservations_phone","inputTraits":{"keyboard":"NamePhonePad"},"t":"Reservierungsnummer"},{"k":"URL","n":"website","v":"firma.com","t":"Webseite"}],"title":"Weitere Informationen","name":"extra"},{"title":"Verwandte Objekte","name":"linked items"},{"fields":[{"k":"string","n":"314584BABD85454B9C85F1EB98266310","v":"iahasfihasf","t":""}],"title":"","name":"Section_B60D69761C9E4C4DB5D5740EBB98A01F"}],"notesPlain":"i am your company pass","reservations_phone":"3234234","member_since_yy":"2019","pin":"iamthepassword","website":"firma.com","additional_no":"11111"},"txTimestamp":1592922270,"createdAt":1589287480,"typeName":"wallet.membership.RewardProgram"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"398E4F11E12A4A4087985CD78A4A60ED","updatedAt":1592922674,"securityLevel":"SL5","openContents":{"tags":["router","wifi"]},"contentsHash":"d18bb610","title":"WLAN-Router","secureContents":{"airport_id":"21","password":"09182490128309128949182048012490124","passwordHistory":[{"value":"sdgsdg","time":1592922674}],"sections":[{"fields":[{"k":"string","v":"Wifi Station","n":"name","inputTraits":{"autocapitalization":"Words"},"t":"Name der Basisstation"},{"k":"concealed","n":"password","v":"09182490128309128949182048012490124","t":"Passwort der Basisstation"},{"k":"string","v":"192.168.1.1","n":"server","inputTraits":{"keyboard":"URL"},"t":"Server\/IP-Adresse"},{"k":"string","n":"airport_id","v":"21","t":"AirPort-ID"},{"k":"string","n":"network_name","v":"Super Lan","t":"Netzwerkname"},{"k":"menu","n":"wireless_security","v":"wpa2e","t":"Drahtlose Sicherheit"},{"k":"concealed","n":"wireless_password","v":"jaidsfhasifhasashfiasf","t":"Passwort des drahtlosen Netzwerks"},{"k":"concealed","n":"disk_password","v":"asfasfasfasfasfasfasf","t":"Passwort für Attached Storage"}],"title":"","name":""},{"title":"Verwandte Objekte","name":"linked items"}],"server":"192.168.1.1","wireless_security":"wpa2e","wireless_password":"jaidsfhasifhasashfiasf","notesPlain":"I am the wifi router","disk_password":"asfasfasfasfasfasfasf","network_name":"Super Lan","name":"Wifi Station"},"txTimestamp":1592922674,"createdAt":1589287507,"typeName":"wallet.computer.Router"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"852175339F36475093661D776688D335","updatedAt":1592921551,"locationKey":"mylogin.com","securityLevel":"SL5","openContents":{"tags":["login","super_guy"]},"contentsHash":"f7170412","title":"Login","location":"mylogin.com","secureContents":{"fields":[{"value":"super_guy","name":"username","type":"T","designation":"username"},{"value":"iampassword","name":"password","type":"P","designation":"password"}],"passwordHistory":[{"value":"sdigjisdgjisdgi","time":1592921551}],"notesPlain":"this is my login","URLs":[{"label":"Webseite","url":"mylogin.com"}]},"txTimestamp":1592921552,"createdAt":1589287531,"typeName":"webforms.WebForm"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"154D7F557CE24EC388E02114BB19D389","updatedAt":1592922405,"securityLevel":"SL5","openContents":{"tags":["lorem ipsum"]},"contentsHash":"c9dc7ea8","title":"Sichere Notiz","secureContents":{"notesPlain":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut nec arcu elementum, auctor magna suscipit, porta elit. Phasellus nec egestas odio. Donec ullamcorper ornare libero, in laoreet mi consectetur vel. Praesent massa lorem, suscipit ornare maximus non, condimentum eu massa. Praesent congue tellus at quam efficitur, eu suscipit lorem molestie. Nam fringilla suscipit odio sed vehicula. Etiam dapibus a orci nec pharetra. Praesent eros nibh, dapibus et convallis non, pellentesque vitae arcu. Mauris quis justo suscipit, fringilla nibh a, convallis urna.","sections":[{"fields":[{"k":"string","n":"A9F4AB076D2944908AC63B957BEF777E","v":"asfasfasf","t":""},{"k":"string","n":"BCFB43A7E57A41349F406284F634A188","v":"dfdddsdfsdfssssdddd","t":"dfsgdfgdfg"}],"title":"","name":"Section_A28694121489442E97A08F64174BD4AA"},{"title":"Verwandte Objekte","name":"linked items"},{"fields":[{"k":"string","n":"0AB7F17AF8BC454F85D30FD6F093234C","v":"iadhsihasfiahsfiasf","t":"dfgdfgdgdgdfgdfgdfgdfg"}],"title":"Other Notes","name":"Section_685EDC3F7B314877A03C11289A590932"}]},"txTimestamp":1592922405,"createdAt":1589287558,"typeName":"securenotes.SecureNote"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"167FE39FF2C34A278BC348AB0589D867","updatedAt":1592921263,"securityLevel":"SL5","contentsHash":"960feb65","title":"Kreditkarte","secureContents":{"pin":"123123","expiry_mm":"4","cashLimit":"250","passwordHistory":[{"value":"sdgsdg","time":1592921263}],"phoneLocal":"012319012391","interest":"0,2","phoneIntl":"89127481","validFrom_yy":"2080","sections":[{"fields":[{"k":"string","inputTraits":{"autocapitalization":"Words","keyboard":"Default"},"n":"cardholder","v":"Max Mustermann","a":{"guarded":"yes"},"t":"Name des Karteninhabers"},{"k":"cctype","v":"amex","n":"type","a":{"guarded":"yes"},"t":"Typ"},{"k":"string","inputTraits":{"keyboard":"NumberPad"},"n":"ccnum","v":"545451548451845184518548158","a":{"guarded":"yes","clipboardFilter":"0123456789"},"t":"Nummer"},{"k":"concealed","inputTraits":{"keyboard":"NumberPad"},"n":"cvv","v":"432","a":{"generate":"off","guarded":"yes"},"t":"Kartenprüfnummer"},{"k":"monthYear","v":202504,"n":"expiry","a":{"guarded":"yes"},"t":"Gültigkeitsdatum"},{"k":"monthYear","v":208001,"n":"validFrom","a":{"guarded":"yes"},"t":"Gültig ab"},{"k":"string","n":"AE92530D6192462197D7300FBAE6B862","v":"gdsfgdfgdfgdfg","t":""}],"title":"","name":""},{"fields":[{"k":"string","v":"Volksbank","n":"bank","inputTraits":{"autocapitalization":"Words","keyboard":"Default"},"t":"Ausstellende Bank"},{"k":"phone","v":"012319012391","n":"phoneLocal","inputTraits":{"keyboard":"NamePhonePad"},"t":"Telefon (lokal)"},{"k":"phone","v":"12491291919","n":"phoneTollFree","inputTraits":{"keyboard":"NamePhonePad"},"t":"Telefon (gebührenfrei)"},{"k":"phone","v":"89127481","n":"phoneIntl","inputTraits":{"keyboard":"NamePhonePad"},"t":"Telefon (international)"},{"k":"URL","n":"website","v":"volksbank.com","t":"Webseite"},{"k":"string","n":"3A210E10EE0E42CB9F5111D814E76CB2","v":"ihsaduihsdfisdf","t":""}],"title":"Kontaktdaten","name":"contactInfo"},{"fields":[{"k":"concealed","v":"123123","n":"pin","inputTraits":{"keyboard":"NumberPad"},"t":"PIN"},{"k":"string","v":"3500","n":"creditLimit","inputTraits":{"keyboard":"NumbersAndPunctuation"},"t":"Kreditlimit"},{"k":"string","v":"250","n":"cashLimit","inputTraits":{"keyboard":"NumbersAndPunctuation"},"t":"Bargeldbezugslimit"},{"k":"string","v":"0,2","n":"interest","inputTraits":{"keyboard":"NumbersAndPunctuation"},"t":"Zinssatz"},{"k":"string","v":"9191201","n":"issuenumber","inputTraits":{"autocorrection":"no"},"t":"Ausstellungsnummer"}],"title":"Zusätzliche Details","name":"details"},{"title":"Verwandte Objekte","name":"linked items"}],"ccnum":"545451548451845184518548158","type":"amex","issuenumber":"9191201","website":"volksbank.com","creditLimit":"3500","notesPlain":"Meine Kreditkarte","expiry_yy":"2025","validFrom_mm":"1","cvv":"432","phoneTollFree":"12491291919","cardholder":"Max Mustermann","bank":"Volksbank"},"txTimestamp":1592921263,"createdAt":1589287570,"typeName":"wallet.financial.CreditCard"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"430EEE5B07404C5092DD3A4C41A00A62","updatedAt":1592922625,"securityLevel":"SL5","contentsHash":"cde0f3af","title":"unique_identifier","secureContents":{"passwordHistory":[{"value":"asfasfasf","time":1590573084},{"value":"asfasfasfsaasasfasf","time":1592922625}],"fields":[{"value":"Ferdinand","name":"username","type":"T","designation":"username"},{"value":"password","name":"password","type":"P","designation":"password"}],"sections":[{"fields":[{"k":"email","n":"DDCABE2A8E3A455DB2B94957F8E87DC6","v":"custom data","t":"custom_field"},{"k":"string","n":"63D160B3F540498D9EF1839258CF31E7","v":"other password","t":"Password"}],"title":"","name":"Section_21571589E30740639B7428A90C73268A"},{"title":"Verwandte Objekte","name":"linked items"},{"fields":[{"k":"string","n":"BC85BF067BB3407085FBF4E9155B9A22","v":"Supergeheim","t":"Benutzername"}],"title":"Wichtig","name":"Section_7A7A1A6B48E94C7EA9CBAB98E0421C7F"}]},"txTimestamp":1592922625,"createdAt":1589290655,"typeName":"webforms.WebForm"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
{"uuid":"A3134E166936480BA6039E2A9B09DB00","updatedAt":1592920193,"securityLevel":"SL5","contentsHash":"a65465ae","title":"Identität","secureContents":{"defphone":"34212341234","birthdate_yy":"2020","company":"Zahnchirurg AG","reminderq":"Was ist mein Passwort?","country":"de","homephone_local":"23412111212","skype":"@zahnfee","icq":"20138429382","cellphone_local":"2341214141","website":"zahnglobal.de","yahoo":"0101010","jobtitle":"Chefzahnklempner","sex":"female","email":"zahnfee@zahnglobal.de","cellphone":"2341214141","remindera":"Was ist nicht mein Passwort?","busphone_local":"23412412413","birthdate_dd":"23","zip":"64114","username":"Zahnfee","initial":"MI","city":"Zahnhausen","occupation":"Zahnchirurg","notesPlain":"das hier ist meine identität","forumsig":"w9018349234928393213","lastname":"Identity","birthdate_mm":"4","msn":"1022410241","firstname":"Mrs Identity","busphone":"23412412413","defphone_local":"34212341234","sections":[{"fields":[{"k":"string","inputTraits":{"autocapitalization":"Words"},"n":"firstname","v":"Mrs Identity","a":{"guarded":"yes"},"t":"Vorname"},{"k":"string","inputTraits":{"autocapitalization":"Words"},"n":"initial","v":"MI","a":{"guarded":"yes"},"t":"Initiale"},{"k":"string","inputTraits":{"autocapitalization":"Words"},"n":"lastname","v":"Identity","a":{"guarded":"yes"},"t":"Nachname"},{"k":"menu","v":"female","n":"sex","a":{"guarded":"yes"},"t":"Geschlecht"},{"k":"date","v":1587643260,"n":"birthdate","a":{"guarded":"yes"},"t":"Geburtsdatum"},{"k":"string","inputTraits":{"autocapitalization":"Words"},"n":"occupation","v":"Zahnchirurg","a":{"guarded":"yes"},"t":"Beruf"},{"k":"string","inputTraits":{"autocapitalization":"Words"},"n":"company","v":"Zahnchirurg AG","a":{"guarded":"yes"},"t":"Firma"},{"k":"string","inputTraits":{"autocapitalization":"Words"},"n":"department","v":"1","a":{"guarded":"yes"},"t":"Abteilung"},{"k":"string","inputTraits":{"autocapitalization":"Words"},"n":"jobtitle","v":"Chefzahnklempner","a":{"guarded":"yes"},"t":"Position"},{"k":"string","n":"A16E62F369E24CE2B965DE7F0FA6CD6D","v":"asifhasifhiasf","t":""}],"title":"Identifikation","name":"name"},{"fields":[{"k":"address","inputTraits":{"autocapitalization":"Sentences"},"n":"address","v":{"street":"Mainstreet 2","city":"Zahnhausen","country":"de","zip":"64114"},"a":{"guarded":"yes"},"t":"Adresse"},{"k":"phone","v":"34212341234","n":"defphone","a":{"guarded":"yes"},"t":"Haupttelefon"},{"k":"phone","v":"23412111212","n":"homephone","a":{"guarded":"yes"},"t":"Festnetz"},{"k":"phone","v":"2341214141","n":"cellphone","a":{"guarded":"yes"},"t":"Mobil"},{"k":"phone","v":"23412412413","n":"busphone","a":{"guarded":"yes"},"t":"Geschäftlich"}],"title":"Adresse","name":"address"},{"fields":[{"k":"string","v":"Zahnfee","n":"username","a":{"guarded":"yes"},"t":"Benutzername"},{"k":"string","n":"reminderq","v":"Was ist mein Passwort?","t":"Erinnerungsfrage"},{"k":"string","n":"remindera","v":"Was ist nicht mein Passwort?","t":"Erinnerungsantwort"},{"k":"string","inputTraits":{"keyboard":"EmailAddress"},"n":"email","v":"zahnfee@zahnglobal.de","a":{"guarded":"yes"},"t":"E-Mail"},{"k":"string","v":"zahnglobal.de","n":"website","inputTraits":{"keyboard":"URL"},"t":"Webseite"},{"k":"string","n":"icq","v":"20138429382","t":"ICQ"},{"k":"string","n":"skype","v":"@zahnfee","t":"Skype"},{"k":"string","n":"aim","v":"01241024","t":"AOL\/AIM"},{"k":"string","n":"yahoo","v":"0101010","t":"Yahoo"},{"k":"string","n":"msn","v":"1022410241","t":"MSN"},{"k":"string","n":"forumsig","v":"w9018349234928393213","t":"Forensignatur"}],"title":"Internetdetails","name":"internet"},{"title":"Verwandte Objekte","name":"linked items"}],"address1":"Mainstreet 2","homephone":"23412111212","department":"1","aim":"01241024"},"txTimestamp":1592920193,"createdAt":1589287607,"typeName":"identities.Identity"}
***5642bee8-a5ff-11dc-8314-0800200c9a66***
"""#
