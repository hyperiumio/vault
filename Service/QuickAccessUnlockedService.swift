actor QuickAccessUnlockedService: QuickAccessUnlockedDependency {
    
}

#if DEBUG
actor QuickAccessUnlockedServiceStub {}

extension QuickAccessUnlockedServiceStub: QuickAccessUnlockedDependency {}
#endif
