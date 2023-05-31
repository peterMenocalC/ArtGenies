//
//  PrivacyPolicyViewController.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 11/10/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet var titleLblText: UILabel!
    @IBOutlet var descLbl: UILabel!
    var registerPage:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.titleLblText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "privacy_policy", comment: "")
        if languageCode == "fr" {
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: "\nPOLITIQUE DE CONFIDENTIALITÉ\n\nCette page web regroupe la Politique de Confidentialité de Art Genies, ces informations sont à utiliser lors de la mise en ligne de l’application mobile Art Genies mais ne s’y limite pas.\n\nINTRODUCTION\n\nDevant le développement des nouveaux outils de communication, il est nécessaire de porter \nune attention particulière à la protection de la vie privée. C’est pourquoi,nous nous\nengageons à respecter la confidentialité des renseignements personnels que nous collectons.\n\nAvertissement : Le Site web/Application mobile développés par Art Genies vous permettent uniquement de vous informer et de vous accompagner dans l’expérience d’une exposition d’art ou pour vous aider à collectionner les œuvres réels et virtuelles.\n\nCOLLECTE DES DONNÉES PERSONNELLES\n\nNous collectons les renseignements suivants :\n\nNom/ Prénom\nAdresse électronique\nNuméro de téléphone\nDonnés de images/QR codes scannés, favorites, partagés, téléchargés, transférés\nInformation sur les œuvres d’art\n\nFICHIERS JOURNAUX\n\nLorsque vous utilisez notre Site web/Application mobile, nous collectons et stockons des informations dans les fichiers journaux de nos serveurs. Cela comprend :\n\nLa façon dont vous avez utilisé le service concerné, telles que vos requêtes de recherche.\nVotre adresse IP.\nDes données relatives aux événements liés à l’appareil que vous utilisez, tels que plantages, activité du système, paramètres du matériel, type et langue de votre navigateur, date et heure de la requête et URL de provenance.\n\nFORMULAIRES ET INTÉRACTIVITÉ\n\nVos renseignements personnels sont collectés par le biais de formulaire, à savoir :\nFormulaire d’inscription au site Web/Application mobile\nSondage d’opinion\nNous utilisons les renseignements ainsi collectés pour les finalités suivantes :\nStatistiques\nContact\nGestion du site Web/Application mobile (présentation, organisation)\nVos renseignements sont également collectés par le biais de l’interactivité pouvant s’établir entre vous et notre site Web/Application mobile et ce, de la façon suivante :\nContact\nGestion du site Web/Application mobile (présentation, organisation)\nNous utilisons les renseignements ainsi collectés pour les finalités suivantes :\nForum ou aire de discussion\nCommentaires\nCorrespondance\n\nAucune publicité ou incitation commerciale n’est présente sur notre Site Web/Application mobile.\n\nDROIT D’OPPOSITION ET DE RETRAIT\n\nNous nous engageons à vous offrir un droit d’opposition et de retrait quant à vos renseignements personnels.\n\nLe droit d’opposition s’entend comme étant la possibilité offerte aux internautes de refuser que leurs renseignements personnels soient utilisés à certaines fins mentionnées lors de la collecte.\n\nLe droit de retrait s’entend comme étant la possibilité offerte aux internautes de demander à ce que leurs renseignements personnels ne figurent plus, par exemple, dans une liste de diffusion.\n\nPour pouvoir exercer ces droits, vous pouvez nous contacter par courrier à l’adresse :\n27-28 Rue du Chemin Vert, Paris 75011\nEmail :wkim@artgenies.com\n\nDROIT D’ACCÈS\n\nNous nous engageons à reconnaître un droit d’accès et de rectification aux personnes concernées désireuses de consulter, modifier, voire radier les informations les concernant.\nL’exercice de ce droit se fera par courrier à l’adresse:\n27-28 Rue du Chemin Vert, Paris 75011\nTéléphone : 01 75 77 87 00\n\nDIVULGATION D’INFORMATIONS PERSONNELLES\n\nIl peut nous arriver de transmettre vos informations personnelles à nos employés ou équipes techniques afin de gérer les comptes utilisateur, le site web/application mobile et les services qui vous sont proposés.  Toute divulgation de données personnelles sera strictement contrôlée et réalisée en accord avec les législations européennes et américaines, mais aussi des pays depuis lesquels notre site web/application mobile est disponible.\n\nNous ne divulguons pas vos données personnelles à une tierce partie sans votre consentement et conformément à la loi en vigueur. Nous vous encourageons à consulter nos termes et conditions d’utilisation.\n\nSÉCURITÉ\n\nLes renseignements personnels que nous collectons sont conservés dans un environnement sécurisé. Les personnes travaillant pour nous sont tenues de respecter la confidentialité de vos informations. Pour assurer la sécurité de vos renseignements personnels, nous avons recours aux mesures suivantes :\n\nProtocole SSL (Secure Sockets Layer)\nGestion des accès – personne autorisée\nGestion des accès – personne concernée\nLogiciel de surveillance du réseau\nSauvegarde informatique\nDéveloppement de certificat numérique\nIdentifiant / mot de passe\nPare-feu (Firewalls)\nHébergeur de données de santé agréé HDS ASIP santé\n\nNous nous engageons à maintenir un haut degré de confidentialité en intégrant les dernières innovations technologiques permettant d’assurer la confidentialité de vos données. Toutefois, comme aucun mécanisme n’offre une sécurité maximale, une part de risque est toujours présente lorsque l’on utilise Internet pour transmettre des renseignements personnels.\n\nLÉGISLATION\n\nNous nous engageons à respecter les dispositions législatives énoncées dans :\nLoi 78-17 Informatique et Libertés.\n\nMISES À JOUR\n\nLes présentes Règles de confidentialité peuvent être amenées à changer, nous publierons toute modification des règles de confidentialité sur cette page et une notification vous sera envoyée afin de vous inciter à consulter les nouvelles règles en vigueur.\n")
            
            self.descLbl.attributedText = attributedText
        }
        else {
            
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: "\nPrivacy Policy\n\nCodaemon built the Art Genies app as a Free app. This SERVICE is provided by Codaemon at no cost and is intended for use as is.\n\nThis page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.\n\nIf you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\n\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Art Genies unless otherwise defined in this Privacy Policy.\n\nInformation Collection and Use\n\nFor a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to name, email, phone number, data for scans, likes, and shares, art information, transfers of art information. The information that we request will be retained by us and used as described in this privacy policy.\n\nThe app does use third party services that may collect information used to identify you.\n\nLink to privacy policy of third party service providers used by the app\n\nGoogle Play Services\n\nLog Data\n\nWe want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.\n\nCookies\n\nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.\n\nThis Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.\n\nService Providers\n\nWe may employ third-party companies and individuals due to the following reasons:\n\nTo facilitate our Service;\n\nTo provide the Service on our behalf;\n\nTo perform Service-related services; or\n\nTo assist us in analyzing how our Service is used.\n\nWe want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.\n\nSecurity\n\nWe value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.\n\nLinks to Other Sites\n\nThis Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.\n\nChildren’s Privacy\n\nThese Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.\n\nChanges to This Privacy Policy\n\nWe may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.\n\nContact Us\n\nIf you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at wkim@artgenies.com, 27-28 Rue du Chemin Vert, 75011 Paris.\n")
            
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 18), subString: "Privacy Policy")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 18), subString: "Information Collection and Use")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 18), subString: "Log Data")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 18), subString: "Cookies")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 18), subString: "Service Providers")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 18), subString: "Links to Other Sites")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 18), subString: "Children’s Privacy")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 18), subString: "Security")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 18), subString: "Changes to This Privacy Policy")
            attributedText.underLine(subString: "Google Play Services")
            attributedText.apply(color: Utility.hexStringToUIColor(hex: "#1E749C"), subString: "Google Play Services")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 18), subString: "Contact Us")
            self.descLbl.attributedText = attributedText
            
            // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func Back_Tapped(_ sender: Any) {
        
        if registerPage == true {
             self.navigationController?.popViewController(animated: true)
        }
        else {
             NavigationController.NavigateToStaticProfile(self)
        }
        
        
       // NavigationController.NavigateToStaticProfile(self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
}





