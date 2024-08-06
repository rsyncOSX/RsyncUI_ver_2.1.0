## Hi there 👋

This code is under development. **DO NOT** fork or use this code. It is not yet verified, completed and there are bugs. 

By Using Swift Package Manager (SPM), source code for e.g. creating parameters to `rsync` from configurations, are made as packages. The old code, the base for packages, is deleted and RsyncUI imports the new packages. By Xcode 16 there is also a new module, Swift Testing, for testing. By creating packages, by Swift Testing, important code is isolated and tested to verify it is working as expected. By SPM and Swift Testing, the code for RsyncUI is modularized, isolated, and tested before committing changes.
