## Hi there 👋

This code is under development. **DO NOT** fork or use this code. It is not yet verified, completed and there are bugs. 

#### Xcode 16, Swift Testing and Swift Package Manager

For RsyncUI only. To be released as part of RsyncUI later in 2024, the work on RsyncUI commenced in August 2024.

By Using Swift Package Manager (SPM), parts of the source code in RsyncUI is extraced and created as packages. One such package is [RsyncArguments](https://github.com/rsyncOSX/RsyncArguments), which create parameters to `rsync` from configurations. The old code, the base for packages, is deleted and RsyncUI imports the new packages. 

In Xcode 16 there is also a new module, Swift Testing, for testing packages. By creating packages and Swift Testing, important code is isolated and tested to verify it is working as expected. By SPM and Swift Testing, the code for RsyncUI is modularized, isolated, and tested before committing changes. One such package is .

This is *work in progress*. I am learning every day and developing new code.
