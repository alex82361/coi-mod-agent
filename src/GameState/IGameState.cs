using System;
using System.Collections.Generic;

namespace CoiModAgent.GameState
{
    public class ResourceState
    {
        public float Food { get; set; }
        public float Water { get; set; }
        public float Fuel { get; set; }
        public float Power { get; set; }
        public float Maintenance { get; set; }
    }

    public class ProductionChainState
    {
        public string Name { get; set; }
        public float Efficiency { get; set; }
        public bool IsActive { get; set; }
    }

    public class WorldState
    {
        public List<ProductionChainState> ProductionChains { get; set; }
        public int PopulationCount { get; set; }
        public float Happiness { get; set; }
    }

    public interface IGameState
    {
        ResourceState GetResources();
        ProductionChainState GetProductionChain(string chainName);
        WorldState GetWorldState();
        Version GetGameVersion();
    }
}