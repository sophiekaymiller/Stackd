//
//  ViewController.swift
//  Stackd
//
//  Created by Sophie Miller on 9/12/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit
import Filestack
import FilestackSDK

class ViewController: UIViewController {

	var oneDayInSeconds: TimeInterval?
	var policy: Policy?
	var client: Filestack.Client?
	var security: Security?
	var handle: String?
	var uploadRequest: CancellableRequest?

	// Create `Config` object.
	var config = Filestack.Config()

	@IBOutlet weak var pickerButton: UIButton!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		
		fileStackInit()
		localUpload()
		uploadLibraryCamera()
		
		let policy = Policy(expiry: .distantFuture,
							call: [.pick, .read, .stat, .write, .writeURL, .store, .convert, .remove, .exif])
		
		// Create `Security` object based on our previously created `Policy` object and app secret obtained from
		// [Filestack Developer Portal](https://dev.filestack.com/).
		guard let security = try? Security(policy: policy, appSecret: "YI6XMQLG6LVABJKEJ2P3JWAFHHU") else {
			fatalError("Unable to instantiate Security object.")
		}
		
		
		// Video quality for video recording (and sometimes exporting.)
		config.videoQuality = .typeHigh
		
		if #available(iOS 11.0, *) {
			// On iOS 11, you can export images in HEIF or JPEG by setting this value to `.current` or `.compatible`
			// respectively.
			// Here we state we prefer HEIF for image export.
			config.imageURLExportPreset = .current
			// On iOS 11, you can decide what format and quality will be used for exported videos.
			// Here we state we want to export HEVC at the highest quality.
			
			config.videoQuality = .typeHigh
		}
		
		// Here you can enumerate the available local sources for the picker.
		// If you simply want to enumerate all the local sources, you may use `LocalSource.all()`, but if you would
		// like to enumerate, let's say the camera source only, you could set it like this:
		//
		//   config.availableLocalSources = [.camera]
		//
		config.availableLocalSources = LocalSource.all()
		
		// Here you can enumerate the available cloud sources for the picker.
		// If you simply want to enumerate all the cloud sources, you may use `CloudSource.all()`, but if you would
		// like to enumerate selected cloud sources, you could set these like this:
		//
		//   config.availableCloudSources = [.dropbox, .googledrive, .googlephotos, .customSource]
		//
		config.availableCloudSources = CloudSource.all()
		
		// Store options for your uploaded files.
		// Here we are saying our storage location is S3 and access for uploaded files should be public.
		let storeOptions = StorageOptions(location: .s3, access: .public)
		
		// Instantiate picker by passing the `StorageOptions` object we just set up.
		let picker = client?.picker(storeOptions: storeOptions)
		
		picker?.pickerDelegate = self
		
		
	}

	func fileStackInit() {

		oneDayInSeconds = 60 * 60 * 24 // expires tomorrow

		policy = Policy(// Set your expiry time (24 hours in our case)
			expiry: Date(timeIntervalSinceNow: oneDayInSeconds ?? TimeInterval.nan),
			// Set the permissions you want your policy to have
			call: [.pick, .read, .store])

		client = Filestack.Client(apiKey: "ANINSQu9HTEieXYZhfYqUz", security: security, config: config)

		// Initialize a `Security` object by providing a `Policy` object and your app secret.
		// You can find and/or enable your app secret in the Developer Portal.
		guard case self.security = try? Security(policy: policy!, appSecret: "I6XMQLG6LVABJKEJ2P3JWAFHHU") else {
			return
		}

		config.appURLScheme = "com.sophieMiller.Stackd"

	}
	@IBAction func pickerTouched(_ sender: Any) {
		
		let storeOptions = StorageOptions(location: .s3, access: .public)
		
		// Instantiate picker by passing the `StorageOptions` object we just set up.
		let picker = client?.picker(storeOptions: storeOptions)
		
		self.present(picker!, animated: true, completion: nil)
	}
	
	func localUpload() {

		let localURL = URL(string: "file:///an-app-sandbox-friendly-local-url")!
		self.uploadRequest = client?.upload(from: localURL, uploadProgress: { (progress) in
			// Here you may update the UI to reflect the upload progress.
			print("progress = \(String(describing: progress))")
		}) { (response) in
			// Try to obtain Filestack handle
			if let json = response?.json,  self.handle == json["handle"] as? String {
				// Use Filestack handle
			} else if (response?.error) != nil {
				// Handle error
			}
		}
	}

	func uploadLibraryCamera() {
		// The view controller that will be presenting the image picker.
		let presentingViewController = self

		// The source type (e.g. `.camera`, `.photoLibrary`)
		let sourceType = UIImagePickerController.SourceType.camera

		self.uploadRequest = client?.uploadFromImagePicker(viewController: presentingViewController, sourceType: sourceType, uploadProgress: { (progress) in

			// Here you may update the UI to reflect the upload progress.
			print("progress = \(String(describing: progress))")
		}) { (response) in

			if response.isEmpty {
				
				return
			}
			print(response.description)
		}
		



	}
}

extension ViewController: PickerNavigationControllerDelegate {
	func pickerUploadedFiles(picker: PickerNavigationController, responses: [NetworkJSONResponse]) {

	}
	
	
	func pickerStoredFile(picker: PickerNavigationController, response: StoreResponse) {
		
		if let contents = response.contents {
			// Our cloud file was stored into the destination location.
			print("Stored file response: \(contents)")
		} else if let error = response.error {
			// The store operation failed.
			print("Error storing file: \(error)")
		}
	}
	
	func pickerUploadedFile(picker: PickerNavigationController, response: NetworkJSONResponse?) {
		
		if let contents = response?.json {
			// Our local file was stored into the destination location.
			print("Uploaded file response: \(contents)")
		} else if let error = response?.error {
			// The upload operation failed.
			print("Error uploading file: \(error)")
		}
	}
}
