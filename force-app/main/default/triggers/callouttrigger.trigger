trigger callouttrigger on Account (before insert,before update) {
    calloutclass.makecallout();
}